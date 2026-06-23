import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/utility.dart';

import 'package:thegreenmall/dashboard/home/model/get_user_store_list_model.dart';

import '../model/payment_intent_model.dart';
import '../model/payment_recipient.dart';
import '../model/qr_payload_model.dart';

/// Drives the whole P2P / P2B barcode-payment flow:
/// scan/lookup -> details -> review -> confirm -> success.
class PaymentController extends GetxController {
  final LocalAuthentication _auth = LocalAuthentication();
  final _uuid = const Uuid();

  // Home tab + payment type
  final RxInt segment = 0.obs; // 0 = Pay/Send, 1 = Receive
  final RxString paymentType = 'p2p'.obs; // 'p2p' | 'p2b'

  // Flow state
  final Rxn<PaymentRecipient> recipient = Rxn<PaymentRecipient>();
  final RxString amountText = ''.obs;
  final RxString note = ''.obs;
  final Rxn<PaymentIntentModel> intent = Rxn<PaymentIntentModel>();

  // UX state
  final RxBool isProcessing = false.obs;
  final RxString errorMessage = ''.obs;

  // Store-owner receive flow: the owner's businesses to choose from.
  final RxList<UserStoresList> ownerStores = <UserStoresList>[].obs;
  final RxBool storesLoading = false.obs;

  // Pay flow (P2P or P2B): when a store owner funds the payment from one of their
  // stores, the chosen store (null = pay from their personal wallet).
  final Rxn<UserStoresList> sourceStore = Rxn<UserStoresList>();

  // P2B pay flow: businesses attached to a looked-up phone number, for the
  // user to pick which one to pay.
  final RxList<PaymentRecipient> businessMatches = <PaymentRecipient>[].obs;

  // The number behind the current business lookup, used to pay by phone when a
  // chosen payee carries no merchant/store id.
  String? _lookupPhone;
  String? _lookupCode;

  /// Idempotency key for the current attempt; regenerated when a new payment
  /// is started so retries of the same attempt are safe.
  String _idempotencyKey = '';

  /// Exactly what resolves the payee for /payment/create — set at resolution
  /// time, because the recipient profile carries only a masked phone.
  /// QR: {payload}, manual P2P: {phone, phone_code}, P2B: {merchant_id}.
  Map<String, dynamic> _payeeRef = {};

  Map<String, String> get _headers => {
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
        // Required so the server's bodyParser.json() parses the request body.
        'Content-Type': 'application/json',
      };

  bool _isOk(dynamic status) =>
      status == ApiConstants.statusCode200 || status == ApiConstants.statusCode201;

  double get amount => double.tryParse(amountText.value.trim()) ?? 0;

  void startNewAttempt() {
    _idempotencyKey = _uuid.v4();
    intent.value = null;
    errorMessage.value = '';
  }

  void resetFlow() {
    recipient.value = null;
    amountText.value = '';
    note.value = '';
    intent.value = null;
    errorMessage.value = '';
    _idempotencyKey = '';
    _payeeRef = {};
    businessMatches.clear();
    sourceStore.value = null;
  }

  /// True when the signed-in user is a store owner — gates the P2P "pay from a
  /// store" selector to owners only.
  bool get isStoreOwner => roleApp.value == Role.storeOwnerRoleText;

  // ---------------------------------------------------------------------------
  // Recipient resolution
  // ---------------------------------------------------------------------------

  /// Decode a scanned QR/barcode. Returns the recipient on success, or null with
  /// [errorMessage] set (caller shows the right error UI: invalid / expired).
  Future<PaymentRecipient?> decodeScannedCode(String raw) async {
    // A store owner may resolve to one of their own stores; load the owner's
    // store list first so [_handleRecipientResponse] can block self-payment.
    await _ensureOwnerStoresLoaded();
    final res = await UserProvider().postWithHeadersApi(
      {"payload": raw},
      ServerCommunicator.baseUrl + ServerCommunicator.paymentQrDecode,
      _headers,
    );
    return _handleRecipientResponse(res, payeeRef: {"payload": raw});
  }

  /// Manual lookup by phone (P2P) or merchant id (P2B).
  Future<PaymentRecipient?> lookupRecipient(
      {String? phone, String? phoneCode, String? merchantId}) async {
    await _ensureOwnerStoresLoaded();
    final body = <String, dynamic>{};
    if (merchantId != null && merchantId.isNotEmpty) {
      body['merchant_id'] = int.tryParse(merchantId) ?? merchantId;
    } else {
      body['phone'] = phone;
      body['phone_code'] = phoneCode;
    }
    final res = await UserProvider().postWithHeadersApi(
      body,
      ServerCommunicator.baseUrl + ServerCommunicator.paymentRecipientLookup,
      _headers,
      showLoading: true,
    );
    return _handleRecipientResponse(res, payeeRef: body);
  }

  /// P2B manual entry: look up every business attached to [phone]. Returns the
  /// list (may be empty) on success, or null with [errorMessage] set on failure.
  /// The caller shows a picker so the user chooses which business to pay.
  Future<List<PaymentRecipient>?> lookupBusinessesByPhone({
    required String phone,
    required String phoneCode,
  }) async {
    await _ensureOwnerStoresLoaded();
    final res = await UserProvider().postWithHeadersApi(
      {"phone": phone, "phone_code": phoneCode, "type": "p2b"},
      ServerCommunicator.baseUrl + ServerCommunicator.paymentRecipientLookup,
      _headers,
      showLoading: true,
    );
    if (res == null) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return null;
    }
    if (_isOk(res.body['status'])) {
      final data = res.body['data'];
      // Remember the looked-up number so a payee with no merchant/store id can
      // still be paid by phone (see [selectBusiness]).
      _lookupPhone = phone;
      _lookupCode = phoneCode;
      // Tolerate three shapes: a bare array in `data`, a wrapped
      // `data.businesses`, or a single recipient object (current backend, which
      // resolves the phone to one person/owner rather than a businesses list).
      final raw = data is List
          ? data
          : (data is Map && data['businesses'] is List
              ? data['businesses'] as List
              : (data is Map ? [data] : const []));
      final list = raw
          .map((e) =>
              PaymentRecipient.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // A store owner must not transfer money between their own stores: drop any
      // match that is one of the owner's stores before showing the picker.
      final ownMatches = list.where(_isOwnStore).length;
      final payable = list.where((r) => !_isOwnStore(r)).toList();
      businessMatches.value = payable;
      if (payable.isEmpty) {
        errorMessage.value = ownMatches > 0
            ? AlertStringConstants.cannotPayOwnStoreText
            : 'No businesses found for this number.';
        return null;
      }
      errorMessage.value = '';
      return payable;
    }
    errorMessage.value =
        res.body['message'] ?? 'No businesses found for this number.';
    return null;
  }

  /// Commit the business the user picked as the payee, then prep the
  /// amount/create step exactly as a successful lookup would.
  void selectBusiness(PaymentRecipient r) {
    recipient.value = r;
    paymentType.value = r.type;
    // Resolve the payee for /payment/create. Prefer a per-store merchant code,
    // then store_id; if neither is present (the backend resolved the phone to a
    // plain user), fall back to paying by the looked-up phone number.
    if (r.merchantId != null) {
      _payeeRef = {"merchant_id": r.merchantId};
    } else if (r.storeId != null) {
      _payeeRef = {"store_id": r.storeId};
    } else {
      _payeeRef = {"phone": _lookupPhone, "phone_code": _lookupCode};
    }
    amountText.value = r.hasFixedAmount ? r.fixedAmount!.toStringAsFixed(2) : '';
    startNewAttempt();
  }

  /// Loads the signed-in owner's stores once, so the own-store guard below has
  /// something to match against. No-op for non-owners or when already loaded.
  Future<void> _ensureOwnerStoresLoaded() async {
    if (roleApp.value != Role.storeOwnerRoleText) return;
    if (ownerStores.isNotEmpty) return;
    await fetchOwnerStores();
  }

  /// True when [r] is a business that belongs to the signed-in store owner.
  /// Matched by store id (owner store ids are strings, recipient ids ints).
  bool _isOwnStore(PaymentRecipient r) {
    if (roleApp.value != Role.storeOwnerRoleText) return false;
    if (r.storeId == null) return false;
    return ownerStores.any((s) => s.storeId == r.storeId.toString());
  }

  PaymentRecipient? _handleRecipientResponse(dynamic res,
      {required Map<String, dynamic> payeeRef}) {
    if (res == null) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return null;
    }
    if (_isOk(res.body['status'])) {
      final r = PaymentRecipient.fromJson(
          Map<String, dynamic>.from(res.body['data']));
      // Block a store owner from paying (transferring to) one of their own
      // stores, whether reached by scanning its code or a merchant-id lookup.
      if (_isOwnStore(r)) {
        errorMessage.value = AlertStringConstants.cannotPayOwnStoreText;
        return null;
      }
      recipient.value = r;
      paymentType.value = r.type;
      _payeeRef = payeeRef;
      errorMessage.value = '';
      // A fixed-amount merchant code pre-fills (and locks) the amount.
      amountText.value =
          r.hasFixedAmount ? r.fixedAmount!.toStringAsFixed(2) : '';
      startNewAttempt();
      return r;
    }
    errorMessage.value = res.body['message'] ?? 'Invalid or unsupported code.';
    return null;
  }

  // ---------------------------------------------------------------------------
  // My / merchant receive code
  // ---------------------------------------------------------------------------

  /// Fetches the businesses owned by the signed-in user so a store-owner can
  /// pick which one to receive into. No-op refresh while already loading.
  Future<void> fetchOwnerStores() async {
    if (storesLoading.value) return;
    storesLoading.value = true;
    final res = await UserProvider().getWithHeadersApi(
      ServerCommunicator.baseUrl + ServerCommunicator.userStore,
      _headers,
      showLoading: false,
    );
    if (res != null && _isOk(res.body['status'])) {
      final model = GetUserStoreListModel.fromJson(
          Map<String, dynamic>.from(res.body));
      ownerStores.value = model.data?.stores ?? <UserStoresList>[];
    }
    storesLoading.value = false;
  }

  Future<QrPayloadModel?> generateMyCode(
      {required String actorType, int? storeId, double? amount}) async {
    final body = <String, dynamic>{"actor_type": actorType};
    if (storeId != null) body['store_id'] = storeId;
    if (amount != null && amount > 0) body['amount'] = amount;
    final res = await UserProvider().postWithHeadersApi(
      body,
      ServerCommunicator.baseUrl + ServerCommunicator.paymentQrGenerate,
      _headers,
    );
    if (res != null && _isOk(res.body['status'])) {
      return QrPayloadModel.fromJson(
          Map<String, dynamic>.from(res.body['data']));
    }
    Utility.showToast(res?.body['message'] ?? 'Unable to generate payment code');
    return null;
  }

  /// "Request money": texts [phone] an SMS (via the backend Pinpoint service)
  /// asking them to pay [amount] to the signed-in user. Returns true on success;
  /// shows a toast and returns false otherwise.
  Future<bool> sendPaymentRequestSms({
    required String phone,
    required String phoneCode,
    required double amount,
    String? note,
  }) async {
    final res = await UserProvider().postWithHeadersApi(
      {
        "phone": phone,
        "phone_code": phoneCode,
        "amount": amount,
        if (note != null && note.trim().isNotEmpty) "note": note.trim(),
      },
      ServerCommunicator.baseUrl + ServerCommunicator.paymentRequestSms,
      _headers,
      showLoading: true,
    );
    if (res != null && _isOk(res.body['status'])) return true;
    Utility.showToast(res?.body['message'] ?? 'Unable to send the request');
    return false;
  }

  // ---------------------------------------------------------------------------
  // Create (Details -> Review)
  // ---------------------------------------------------------------------------

  /// Validates locally, then creates the payment intent. On a KYC gate it returns
  /// 'KYC_REQUIRED' so the caller can route to license upload. Returns 'OK' on
  /// success, or null/other code on failure (errorMessage set).
  Future<String?> createPayment() async {
    final r = recipient.value;
    if (r == null) {
      errorMessage.value = 'No recipient selected';
      return null;
    }
    final amt = amount;
    if (amt <= 0) {
      errorMessage.value = 'Enter a valid amount';
      return null;
    }
    if (_idempotencyKey.isEmpty) startNewAttempt();

    final body = <String, dynamic>{
      "idempotency_key": _idempotencyKey,
      "amount": amt,
      "note": note.value,
      // Forward the exact payee reference captured at resolution time
      // (QR payload, manual phone, or merchant id).
      ..._payeeRef,
    };

    // A store owner can fund the send (P2P or P2B) from one of their stores. The
    // backend authorizes ownership and debits that store's wallet.
    final src = sourceStore.value;
    if (src?.storeId != null) {
      final id = int.tryParse(src!.storeId!);
      if (id != null) body['initiator_store_id'] = id;
    }

    final res = await UserProvider().postWithHeadersApi(
      body,
      ServerCommunicator.baseUrl + ServerCommunicator.paymentCreate,
      _headers,
      showLoading: true,
    );

    if (res == null) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return null;
    }
    if (_isOk(res.body['status'])) {
      intent.value =
          PaymentIntentModel.fromJson(Map<String, dynamic>.from(res.body['data']));
      errorMessage.value = '';
      return 'OK';
    }

    final code = res.body['code'];
    errorMessage.value = res.body['message'] ?? 'Unable to start payment';
    return code ?? 'ERROR';
  }

  // ---------------------------------------------------------------------------
  // Confirm (Review -> Processing -> Success)
  // ---------------------------------------------------------------------------

  /// Runs biometric (if required) then confirms. Returns the succeeded intent,
  /// or null with [errorMessage] set. Safe to retry with the same intent.
  Future<PaymentIntentModel?> confirmPayment() async {
    final i = intent.value;
    if (i == null) {
      errorMessage.value = 'No payment to confirm';
      return null;
    }

    bool biometricVerified = false;
    if (i.biometricRequired) {
      biometricVerified = await _runBiometric();
      if (!biometricVerified) {
        errorMessage.value = 'Authentication was not completed';
        return null;
      }
    }

    isProcessing.value = true;
    errorMessage.value = '';

    PaymentIntentModel? result;
    // Safe retry: same idempotency_key + intent id (spec 5.5.3, max 2 retries).
    for (int attempt = 0; attempt <= 2; attempt++) {
      final res = await UserProvider().postWithHeadersApi(
        {
          "payment_intent_id": i.id,
          "idempotency_key": _idempotencyKey,
          "biometric_verified": biometricVerified,
        },
        ServerCommunicator.baseUrl + ServerCommunicator.paymentConfirm,
        _headers,
      );

      if (res != null && _isOk(res.body['status'])) {
        result = PaymentIntentModel.fromJson(
            Map<String, dynamic>.from(res.body['data']));
        break;
      }

      // Typed, non-retryable failures: stop immediately.
      final code = res?.body['code'];
      if (res != null && _nonRetryable(code)) {
        errorMessage.value = res.body['message'] ?? 'Payment failed';
        break;
      }
      if (attempt == 2) {
        errorMessage.value =
            res?.body['message'] ?? 'Payment could not be completed. Please try again.';
      }
    }

    isProcessing.value = false;
    return result;
  }

  bool _nonRetryable(String? code) {
    const codes = {
      'INSUFFICIENT_BALANCE',
      'BIOMETRIC_REQUIRED',
      'INTENT_NOT_PAYABLE',
      'INTENT_EXPIRED',
      'INTENT_NOT_FOUND',
      'DAILY_LIMIT_EXCEEDED',
      'VELOCITY_EXCEEDED',
      'KYC_REQUIRED',
    };
    return code != null && codes.contains(code);
  }

  Future<bool> _runBiometric() async {
    try {
      final canCheck = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (!canCheck) {
        // No biometric hardware enrolled: allow the payment to proceed rather
        // than hard-blocking the user (server still treats it as verified intent).
        return true;
      }
      return await _auth.authenticate(
        localizedReason: 'Authenticate to confirm your payment',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException {
      return false;
    }
  }

  Future<void> cancelPayment() async {
    final i = intent.value;
    if (i == null || i.id == null) return;
    await UserProvider().postWithHeadersApi(
      {"payment_intent_id": i.id},
      ServerCommunicator.baseUrl + ServerCommunicator.paymentCancel,
      _headers,
    );
  }
}

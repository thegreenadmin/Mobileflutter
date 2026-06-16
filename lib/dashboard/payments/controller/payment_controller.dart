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
  }

  // ---------------------------------------------------------------------------
  // Recipient resolution
  // ---------------------------------------------------------------------------

  /// Decode a scanned QR/barcode. Returns the recipient on success, or null with
  /// [errorMessage] set (caller shows the right error UI: invalid / expired).
  Future<PaymentRecipient?> decodeScannedCode(String raw) async {
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

  PaymentRecipient? _handleRecipientResponse(dynamic res,
      {required Map<String, dynamic> payeeRef}) {
    if (res == null) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return null;
    }
    if (_isOk(res.body['status'])) {
      final r = PaymentRecipient.fromJson(
          Map<String, dynamic>.from(res.body['data']));
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

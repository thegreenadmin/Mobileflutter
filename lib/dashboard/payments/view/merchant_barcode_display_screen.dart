import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:thegreenmall/dashboard/home/model/get_user_store_list_model.dart';

import '../controller/payment_controller.dart';
import '../model/qr_payload_model.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Displays a scannable dynamic payment code for a user (Receive) or merchant
/// (P2B), with an expiry countdown and auto-refresh (spec 5.7).
class MerchantBarcodeDisplayScreen extends StatefulWidget {
  const MerchantBarcodeDisplayScreen({super.key});

  @override
  State<MerchantBarcodeDisplayScreen> createState() =>
      _MerchantBarcodeDisplayScreenState();
}

class _MerchantBarcodeDisplayScreenState
    extends State<MerchantBarcodeDisplayScreen> {
  final PaymentController c = Get.find<PaymentController>();

  /// Base intent of the screen, set from route args:
  /// - `_pickStore`: show the "Select business" form before generating.
  /// - `_requireAmount`: include the "Amount to receive" field (merchant request).
  /// - `_allowPersonal`: offer "My personal code" alongside the stores.
  late final bool _pickStore;
  late final bool _requireAmount;
  late final bool _allowPersonal;

  int? _storeId;
  UserStoresList? _selectedStore; // null => personal (when allowed)
  double? _amount;
  final _amountCtrl = TextEditingController();

  QrPayloadModel? _qr;
  bool _loading = false;
  int _remaining = 0;
  Timer? _timer;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Read from the route settings (reliable inside the nested navigator) and
    // fall back to Get.arguments for safety.
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ??
        (Get.arguments as Map?) ??
        {};
    final actorType = args['actor_type'] ?? 'user';
    _requireAmount = args['require_amount'] == true;
    _pickStore = args['pick_store'] == true || _requireAmount;
    // "Show my code" (user actor) can also fall back to a personal code.
    _allowPersonal = actorType != 'merchant';
    _storeId = args['store_id'];

    if (_pickStore) {
      // Load the owner's businesses so they can pick one in the form.
      c.fetchOwnerStores();
    }
    // Generate immediately only when there is nothing to pick.
    if (!_pickStore || _storeId != null) {
      _generate();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amountCtrl.dispose();
    super.dispose();
  }

  /// True once a generated code exists for a store (vs a personal code).
  bool get _showingStoreCode => _qr != null && _selectedStore != null;

  Future<void> _generate() async {
    // A selected store => merchant code; otherwise a personal (user) code.
    final actorType = _selectedStore != null ? 'merchant' : 'user';
    setState(() => _loading = true);
    final qr = await c.generateMyCode(
        actorType: actorType, storeId: _storeId, amount: _amount);
    if (!mounted) return;
    setState(() {
      _qr = qr;
      _loading = false;
    });
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    if (_qr?.expiresAt == null) return;
    void tick() {
      final secs = _qr!.expiresAt!.difference(DateTime.now()).inSeconds;
      setState(() => _remaining = secs > 0 ? secs : 0);
      if (secs <= 0) _timer?.cancel();
    }

    tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        children: [
          PayAppBar(
            title: _requireAmount ? 'Generate a payment code' : 'My Payment Code',
            subtitle: _requireAmount
                ? 'Let customers scan to pay'
                : 'Let others scan to pay you',
          ),
          Expanded(
            child: _pickStore && _qr == null
                ? _buildPickerForm()
                : _buildCode(),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerForm() {
    return Obx(() {
      if (c.storesLoading.value && c.ownerStores.isEmpty) {
        return const Center(
            child: CircularProgressIndicator(color: PayTheme.accent));
      }
      // Stores are mandatory only when there is no personal-code fallback.
      if (c.ownerStores.isEmpty && !_allowPersonal) {
        return PayMessageView(
          icon: Icons.storefront_outlined,
          title: 'No businesses found',
          message: "We couldn't find any stores linked to your account.",
          actionText: 'Retry',
          onAction: c.fetchOwnerStores,
        );
      }
      // Keep the selection valid if the list reloads.
      if (_selectedStore != null &&
          !c.ownerStores.any((s) => s.storeId == _selectedStore!.storeId)) {
        _selectedStore = null;
        _storeId = null;
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: PayTheme.hPad, vertical: PayTheme.sectionGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select business', style: PayTheme.label),
            const SizedBox(height: 8),
            PayCard(
              padding: const EdgeInsets.symmetric(horizontal: PayTheme.itemGap),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<UserStoresList?>(
                  isExpanded: true,
                  value: _selectedStore,
                  hint: const Text('Choose a store', style: PayTheme.bodyMuted),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: PayTheme.secondaryText),
                  items: [
                    if (_allowPersonal)
                      const DropdownMenuItem<UserStoresList?>(
                        value: null,
                        child: Row(
                          children: [
                            Icon(Icons.person_rounded,
                                color: PayTheme.accent, size: 22),
                            SizedBox(width: 12),
                            Text('My personal code', style: PayTheme.body),
                          ],
                        ),
                      ),
                    ...c.ownerStores.map((s) => DropdownMenuItem<UserStoresList?>(
                          value: s,
                          child: Row(
                            children: [
                              const Icon(Icons.storefront_rounded,
                                  color: PayTheme.accent, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  s.storeName ?? 'Store',
                                  overflow: TextOverflow.ellipsis,
                                  style: PayTheme.body,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                  onChanged: (s) => setState(() {
                    _selectedStore = s;
                    _storeId = s == null ? null : int.tryParse(s.storeId ?? '');
                  }),
                ),
              ),
            ),
            if (_requireAmount) ...[
              const SizedBox(height: PayTheme.sectionGap),
              const Text('Amount to receive', style: PayTheme.label),
              const SizedBox(height: 8),
              PayCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: PayTheme.itemGap, vertical: 4),
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: PayTheme.primaryText),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: PayTheme.primaryText),
                    hintText: '0.00',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This amount will be encoded in the barcode along with your Merchant Store ID.',
                style: PayTheme.caption,
              ),
            ],
            const SizedBox(height: PayTheme.sectionGap),
            PayButton(
              text: 'Generate code',
              loading: _loading,
              onTap: _formValid ? _submitPicker : null,
            ),
          ],
        ),
      );
    });
  }

  bool get _formValid {
    if (!_requireAmount) return true; // personal or any store is fine
    final amt = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    return _storeId != null && amt > 0;
  }

  void _submitPicker() {
    if (_requireAmount) {
      final amt = double.tryParse(_amountCtrl.text.trim()) ?? 0;
      if (_storeId == null || amt <= 0) return;
      _amount = amt;
    }
    _generate();
  }

  Widget _buildCode() {
    if (_loading && _qr == null) {
      return const Center(child: CircularProgressIndicator(color: PayTheme.accent));
    }
    if (_qr == null) {
      return PayMessageView(
        icon: Icons.qr_code_2_outlined,
        title: 'Unable to load code',
        message: 'Please try again.',
        actionText: 'Retry',
        onAction: _generate,
      );
    }
    final expired = _remaining <= 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        children: [
          const SizedBox(height: PayTheme.sectionGap),
          if (_amount != null) ...[
            Text('\$ ${_amount!.toStringAsFixed(2)}',
                style: PayTheme.largeHeader),
            if (_selectedStore?.storeName != null)
              Text(_selectedStore!.storeName!, style: PayTheme.bodyMuted),
            const SizedBox(height: PayTheme.itemGap),
          ] else if (_showingStoreCode &&
              _selectedStore?.storeName != null) ...[
            Text(_selectedStore!.storeName!, style: PayTheme.cardTitle),
            const SizedBox(height: PayTheme.itemGap),
          ],
          PayCard(
            padding: const EdgeInsets.all(PayTheme.sectionGap),
            child: Column(
              children: [
                Opacity(
                  opacity: expired ? 0.25 : 1,
                  child: QrImageView(
                    data: _qr!.qrString,
                    size: 220,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: PayTheme.itemGap),
                if (expired)
                  Column(
                    children: [
                      const Text('This code has expired',
                          style: TextStyle(color: PayTheme.error)),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _generate,
                        icon: const Icon(Icons.refresh, color: PayTheme.accent),
                        label: const Text('Refresh code',
                            style: TextStyle(color: PayTheme.accent)),
                      ),
                    ],
                  )
                else
                  Text('Expires in ${_format(_remaining)}', style: PayTheme.bodyMuted),
              ],
            ),
          ),
          const SizedBox(height: PayTheme.itemGap),
          Text(
            _showingStoreCode
                ? 'Ask the customer to scan this code to complete payment.'
                : 'Ask the sender to scan this code to pay you.',
            style: PayTheme.bodyMuted,
            textAlign: TextAlign.center,
          ),
          if (_pickStore) ...[
            const SizedBox(height: PayTheme.itemGap),
            TextButton.icon(
              onPressed: _editPickerDetails,
              icon: const Icon(Icons.edit_outlined,
                  color: PayTheme.accent, size: 20),
              label: Text(
                  _requireAmount ? 'Change amount / store' : 'Change business',
                  style: const TextStyle(color: PayTheme.accent)),
            ),
          ],
        ],
      ),
    );
  }

  /// Returns to the picker (keeping the current store/amount) so the owner can
  /// adjust and regenerate without leaving the screen.
  void _editPickerDetails() {
    _timer?.cancel();
    setState(() {
      _qr = null;
      _remaining = 0;
    });
  }

  String _format(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

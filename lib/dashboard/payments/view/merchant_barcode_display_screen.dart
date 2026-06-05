import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  late final String _actorType;
  int? _storeId;
  final _storeIdCtrl = TextEditingController();

  QrPayloadModel? _qr;
  bool _loading = false;
  int _remaining = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? {};
    _actorType = args['actor_type'] ?? 'user';
    _storeId = args['store_id'];
    if (_actorType == 'user' || _storeId != null) {
      _generate();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _storeIdCtrl.dispose();
    super.dispose();
  }

  bool get _isMerchant => _actorType == 'merchant';

  Future<void> _generate() async {
    setState(() => _loading = true);
    final qr = await c.generateMyCode(actorType: _actorType, storeId: _storeId);
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
            title: _isMerchant ? 'Merchant Payment Code' : 'My Payment Code',
            subtitle: _isMerchant ? 'Let customers scan to pay' : 'Let others scan to pay you',
          ),
          Expanded(
            child: _isMerchant && _storeId == null && _qr == null
                ? _buildStoreIdPrompt()
                : _buildCode(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreIdPrompt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter your Store / Merchant ID to generate a payment code',
              style: PayTheme.bodyMuted, textAlign: TextAlign.center),
          const SizedBox(height: PayTheme.itemGap),
          TextField(
            controller: _storeIdCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Store ID',
              filled: true,
              fillColor: PayTheme.cardSurface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: PayTheme.sectionGap),
          PayButton(
            text: 'Generate Code',
            loading: _loading,
            onTap: () {
              final id = int.tryParse(_storeIdCtrl.text.trim());
              if (id == null) return;
              setState(() => _storeId = id);
              _generate();
            },
          ),
        ],
      ),
    );
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
            _isMerchant
                ? 'Ask the customer to scan this code to complete payment.'
                : 'Ask the sender to scan this code to pay you.',
            style: PayTheme.bodyMuted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _format(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

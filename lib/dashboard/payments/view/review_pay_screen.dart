import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Final review before submitting the payment (spec 5.4).
class ReviewPayScreen extends StatelessWidget {
  const ReviewPayScreen({super.key});

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PaymentController>();
    final r = c.recipient.value;
    final i = c.intent.value;
    final total = i?.total ?? c.amount;

    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        children: [
          PayAppBar(
            title: r?.isMerchant == true ? 'P2B – Review & Pay' : 'P2P – Review & Pay',
            subtitle: 'Confirm your payment',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      PayAvatar(imageUrl: r?.image, name: r?.name ?? '', size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r?.name ?? '', style: PayTheme.body),
                            if (r?.phone != null && r!.phone!.isNotEmpty)
                              Text('${r.phoneCode ?? ''} ${r.phone}'.trim(),
                                  style: PayTheme.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PayTheme.itemGap),
                  PayCard(
                    child: Column(
                      children: [
                        PayRow('Amount', _money(i?.amount ?? c.amount)),
                        PayRow('Fee', _money(i?.fee ?? 0)),
                        const Divider(height: 20),
                        PayRow('Total', _money(total),
                            emphasize: true, valueColor: PayTheme.accent),
                      ],
                    ),
                  ),
                  const SizedBox(height: PayTheme.sectionGap),
                  const Text('Payment Method', style: PayTheme.label),
                  const SizedBox(height: 10),
                  const _WalletMethod(),
                  const SizedBox(height: PayTheme.itemGap),
                  PayCard(
                    color: const Color(0xFFEFF8FB),
                    child: Row(
                      children: const [
                        Icon(Icons.lock_outline, size: 20, color: PayTheme.secondaryText),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('Your payment is secured with 256-bit encryption',
                              style: PayTheme.caption),
                        ),
                      ],
                    ),
                  ),
                  if (i?.biometricRequired == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.fingerprint, size: 18, color: PayTheme.secondaryText),
                          SizedBox(width: 6),
                          Text('Biometric authentication required',
                              style: PayTheme.caption),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(PayTheme.hPad),
              child: PayButton(
                text: 'Pay ${_money(total)}',
                onTap: () => Get.toNamed(PaymentRoutes.processing),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletMethod extends StatelessWidget {
  const _WalletMethod();

  @override
  Widget build(BuildContext context) {
    return PayCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: PayTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined, color: PayTheme.accent),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TGM Wallet', style: PayTheme.body),
                Text('Pay from your wallet balance', style: PayTheme.caption),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: PayTheme.success),
        ],
      ),
    );
  }
}

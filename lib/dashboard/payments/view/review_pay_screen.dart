import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/wallet/view/add_money_to_wallet_customer.dart';
import 'package:thegreenmall/utils/global_share_data.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Final review before submitting the payment (spec 5.4).
class ReviewPayScreen extends StatefulWidget {
  const ReviewPayScreen({super.key});

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
  final PaymentController c = Get.find<PaymentController>();

  @override
  void initState() {
    super.initState();
    // Balance backs the insufficient-funds banner + pay-button guard below.
    c.loadWalletBalance();
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  /// Same recovery path as the cart's insufficient-funds banner: top-up
  /// screen pushed on the host nested navigator, balance re-checked on return.
  Future<void> _openAddMoney() async {
    await Get.to(() => const AddMoneyToWalletUser(isFromCartScreen: true),
        id: pageIdApp.value);
    c.loadWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Obx(() {
                // Only a definite shortfall blocks paying: while the balance is
                // still loading (null) the server-side check remains the guard.
                final bal = c.walletBalance.value;
                final insufficient = bal != null && bal < total;
                // Store-funded sends can't be topped up from here; owners add
                // money from the wallet tab instead.
                final canAddMoney = c.sourceStore.value == null;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (insufficient) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PayTheme.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Insufficient funds (${_money(bal)})',
                                style: const TextStyle(
                                    color: PayTheme.error,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (canAddMoney)
                              InkWell(
                                onTap: _openAddMoney,
                                child: const Text(
                                  'Add funds',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: PayTheme.error,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    PayButton(
                      text: 'Pay ${_money(total)}',
                      onTap: insufficient
                          ? null
                          : () => Get.toNamed(PaymentRoutes.processing),
                    ),
                  ],
                );
              }),
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
    // When a store owner funds a P2P send from one of their stores, show that
    // store as the source instead of the personal wallet.
    final store = Get.find<PaymentController>().sourceStore.value;
    final title = store?.storeName ?? 'TGM Wallet';
    final subtitle = store != null
        ? 'Pay from this store\'s wallet balance'
        : 'Pay from your wallet balance';
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
            child: Icon(
                store != null
                    ? Icons.storefront_outlined
                    : Icons.account_balance_wallet_outlined,
                color: PayTheme.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: PayTheme.body),
                Text(subtitle, style: PayTheme.caption),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: PayTheme.success),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/image_constants.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import '../model/payment_intent_model.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Success confirmation + receipt summary (spec 5.6).
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PaymentController>();
    final PaymentIntentModel i =
        ((Get.arguments as Map?)?['intent'] as PaymentIntentModel?) ?? c.intent.value!;
    final r = c.recipient.value;
    final now = DateTime.now();
    final txnId = i.transactionId != null ? 'TXN${i.transactionId}' : '—';
    final dateStr =
        '${_month(now.month)} ${now.day}, ${now.year} • ${_time(now)}';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: PayTheme.background,
        body: SafeArea(
          child: Column(
            children: [
              // TGM logo leads the screen, matching the rest of the app's headers.
              Padding(
                padding: const EdgeInsets.fromLTRB(PayTheme.hPad, 8, PayTheme.hPad, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(ImageConstants.homeMall, scale: 4),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
                  child: Column(
                    children: [
                      const SizedBox(height: PayTheme.sectionGap),
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          color: PayTheme.success.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: PayTheme.success, size: 48),
                      ),
                      const SizedBox(height: PayTheme.itemGap),
                      const Text('Payment Successful!', style: PayTheme.cardTitle),
                      const SizedBox(height: 6),
                      Text('You have sent', style: PayTheme.bodyMuted),
                      const SizedBox(height: 4),
                      Text(_money(i.amount),
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: PayTheme.success)),
                      const SizedBox(height: 4),
                      Text('to', style: PayTheme.bodyMuted),
                      Text(r?.name ?? '', style: PayTheme.cardTitle),
                      const SizedBox(height: PayTheme.sectionGap),
                      PayCard(
                        child: Column(
                          children: [
                            _ReceiptRow('Transaction ID', txnId),
                            _ReceiptRow('Date & Time', dateStr),
                            _ReceiptRow('Payment Method',
                                c.sourceStore.value?.storeName ?? 'TGM Wallet'),
                            _ReceiptRow('Amount', _money(i.amount)),
                            if (i.fee > 0) _ReceiptRow('Fee', _money(i.fee)),
                            if (i.fee > 0)
                              _ReceiptRow('Recipient received', _money(i.netAmount)),
                            if (i.walletBalance != null)
                              _ReceiptRow(
                                  c.sourceStore.value != null
                                      ? 'Store Balance'
                                      : 'Wallet Balance',
                                  _money(i.walletBalance!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(PayTheme.hPad),
                child: PayButton(
                        text: 'Done',
                        onTap: () {
                          c.resetFlow();
                          // The shell lives inside the home tab's nested
                          // navigator; grab its inner navigator before popping
                          // so we can dismiss the shell from its host below.
                          final innerNav = Get
                              .nestedKey(PaymentRoutes.navId)
                              ?.currentState;
                          // Leave the root-level terminal screens (processing /
                          // success) and return to the main app shell.
                          Get.until((route) =>
                              route.settings.name == '/bottomNavigation' ||
                              route.isFirst);
                          // Pop the payments shell off the home tab so the
                          // user lands back on the Home screen. Must search
                          // from the inner navigator's ancestors (Navigator.of
                          // would return the inner navigator itself) and use a
                          // plain pop(): maybePop() would consult the shell's
                          // PopScope(canPop: false) and hang.
                          final host = innerNav?.context
                              .findAncestorStateOfType<NavigatorState>();
                          if (host != null && host.canPop()) {
                            host.pop();
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _month(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];

  static String _time(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ap';
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: PayTheme.bodyMuted),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: PayTheme.primaryText)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Entry point for all payment workflows (spec 5.1). Pay/Send <-> Receive tabs
/// and the P2P / P2B option cards.
class PaymentsHomeScreen extends StatelessWidget {
  const PaymentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PaymentController>();
    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PayAppBar(title: 'Payments', subtitle: 'Send or receive money'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
            child: Obx(() => _SegmentedControl(
                  index: c.segment.value,
                  onChanged: (i) => c.segment.value = i,
                )),
          ),
          const SizedBox(height: PayTheme.sectionGap),
          Expanded(
            child: Obx(() => c.segment.value == 0
                ? const _PayTab()
                : const _ReceiveTab()),
          ),
        ],
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _SegmentedControl({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _seg('Pay / Send', 0),
          _seg('Receive', 1),
        ],
      ),
    );
  }

  Widget _seg(String text, int i) {
    final selected = index == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? PayTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : PayTheme.secondaryText,
              )),
        ),
      ),
    );
  }
}

class _PayTab extends StatelessWidget {
  const _PayTab();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PaymentController>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose payment type', style: PayTheme.label),
          const SizedBox(height: PayTheme.itemGap),
          _OptionCard(
            icon: Icons.people_alt_rounded,
            title: 'P2P – Pay a Person',
            subtitle: 'Send money to friends and family',
            onTap: () {
              c.paymentType.value = 'p2p';
              c.resetFlow();
              Get.toNamed(PaymentRoutes.scanner,
                  id: PaymentRoutes.navId, arguments: {'type': 'p2p'});
            },
          ),
          const SizedBox(height: PayTheme.itemGap),
          _OptionCard(
            icon: Icons.storefront_rounded,
            title: 'P2B – Pay a Business',
            subtitle: 'Pay at stores and businesses',
            onTap: () {
              c.paymentType.value = 'p2b';
              c.resetFlow();
              Get.toNamed(PaymentRoutes.scanner,
                  id: PaymentRoutes.navId, arguments: {'type': 'p2b'});
            },
          ),
          const SizedBox(height: PayTheme.sectionGap),
          PayCard(
            color: const Color(0xFFEFF8FB),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How it works', style: PayTheme.label),
                      SizedBox(height: 4),
                      Text(
                        'Use barcode to send or receive payments instantly and securely.',
                        style: PayTheme.bodyMuted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.verified_user_rounded, color: PayTheme.accent.withOpacity(0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiveTab extends StatelessWidget {
  const _ReceiveTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Get paid', style: PayTheme.label),
          const SizedBox(height: PayTheme.itemGap),
          _OptionCard(
            icon: Icons.qr_code_2_rounded,
            title: 'Show my code',
            subtitle: 'Let another TGM user scan to pay you',
            onTap: () => Get.toNamed(PaymentRoutes.merchantCode,
                id: PaymentRoutes.navId, arguments: {'actor_type': 'user'}),
          ),
          const SizedBox(height: PayTheme.itemGap),
          _OptionCard(
            icon: Icons.storefront_rounded,
            title: 'Merchant payment code',
            subtitle: 'Display a code for customers to scan',
            onTap: () => Get.toNamed(PaymentRoutes.merchantCode,
                id: PaymentRoutes.navId, arguments: {'actor_type': 'merchant'}),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _OptionCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(PayTheme.cardRadius),
      onTap: onTap,
      child: PayCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: PayTheme.accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: PayTheme.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: PayTheme.cardTitle),
                  const SizedBox(height: 4),
                  Text(subtitle, style: PayTheme.bodyMuted),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: PayTheme.secondaryText),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/payment_controller.dart';
import '../model/payment_recipient.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// After a P2B phone lookup, lets the user pick which business attached to that
/// number they want to pay, then continues into the amount/review flow.
class BusinessSelectScreen extends StatefulWidget {
  const BusinessSelectScreen({super.key});

  @override
  State<BusinessSelectScreen> createState() => _BusinessSelectScreenState();
}

class _BusinessSelectScreenState extends State<BusinessSelectScreen> {
  final PaymentController c = Get.find<PaymentController>();
  PaymentRecipient? _selected;

  @override
  void initState() {
    super.initState();
    // Pre-select the only option so a single-business number is one tap.
    if (c.businessMatches.length == 1) _selected = c.businessMatches.first;
  }

  void _continue() {
    final business = _selected;
    if (business == null) return;
    c.selectBusiness(business);
    Get.toNamed(PaymentRoutes.details, id: PaymentRoutes.navId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PayAppBar(
            title: 'Select Business',
            subtitle: 'Choose the business to pay',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Business', style: PayTheme.label),
                const SizedBox(height: PayTheme.itemGap),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: PayTheme.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: PayTheme.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PaymentRecipient>(
                      isExpanded: true,
                      value: _selected,
                      hint: const Text('Select a business',
                          style: PayTheme.bodyMuted),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: PayTheme.secondaryText),
                      items: c.businessMatches
                          .map((b) => DropdownMenuItem<PaymentRecipient>(
                                value: b,
                                child: _BusinessRow(business: b),
                              ))
                          .toList(),
                      onChanged: (b) => setState(() => _selected = b),
                    ),
                  ),
                ),
                const SizedBox(height: PayTheme.sectionGap),
                PayButton(
                  text: 'Continue',
                  onTap: _selected == null ? null : _continue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessRow extends StatelessWidget {
  final PaymentRecipient business;
  const _BusinessRow({required this.business});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          PayAvatar(imageUrl: business.image, name: business.name, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              business.name,
              style: PayTheme.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

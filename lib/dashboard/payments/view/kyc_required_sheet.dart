import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/home/view/account/account_id_screen.dart';

import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Shown when the backend gates a P2P payment on KYC (verified Driving License).
/// Routes the user to the existing identity-proof upload screen, then back.
void showKycRequiredSheet(BuildContext context, {required String message}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: PayTheme.cardSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(PayTheme.sectionGap),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: PayTheme.warning.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.badge_outlined, color: PayTheme.warning, size: 28),
          ),
          const SizedBox(height: 16),
          const Text('Verify your identity', style: PayTheme.cardTitle),
          const SizedBox(height: 8),
          Text(
            message.isEmpty
                ? 'Please upload and verify your Driving License to send money.'
                : message,
            style: PayTheme.bodyMuted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PayTheme.sectionGap),
          PayButton(
            text: 'Upload Driving License',
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => const AccountIdScreen());
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not now', style: TextStyle(color: PayTheme.secondaryText)),
          ),
        ],
      ),
    ),
  );
}

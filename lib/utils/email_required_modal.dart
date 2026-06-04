import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_edit_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Shows a blocking modal when a logged-in user without an email tries to use
/// wallet/Stripe features. Mirrors [GuestAccessModal]: the primary action takes
/// the user straight to the profile edit form to add their email, while
/// "Maybe Later" returns them to Home. It is not dismissible by tapping outside,
/// so wallet features cannot be reached until an email is added.
class EmailRequiredModal {
  static bool _isShowing = false;

  static void show({
    String? title,
    String? message,
    VoidCallback? onLater,
    VoidCallback? onUpdated,
  }) {
    if (_isShowing) return;
    _isShowing = true;
    Get.dialog(
      // Not dismissible by tapping outside — the user must either add an email
      // ("Update Email") or explicitly choose "Maybe Later" (which returns Home).
      // This prevents bypassing the gate to reach wallet features.
      barrierDismissible: false,
      _EmailRequiredDialog(
        title: title ?? StringConstants.emailRequiredTitle,
        message: message ?? StringConstants.emailRequiredMessage,
        onLater: onLater,
        onUpdated: onUpdated,
      ),
    ).whenComplete(() => _isShowing = false);
  }
}

class _EmailRequiredDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onLater;
  final VoidCallback? onUpdated;

  const _EmailRequiredDialog({
    required this.title,
    required this.message,
    this.onLater,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_unread_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            height20SizedBox,
            Text(
              title,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            height10SizedBox,
            Text(
              message,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            height30SizedBox,
            // Update Email -> profile edit form
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  // Push the edit form inside the active tab's nested navigator
                  // (matches the app's navigation pattern) so back/save returns
                  // to the wallet screen. Re-check the gate on return.
                  Get.to(() => const PersonalInfoEditScreen(),
                          id: pageIdApp.value)
                      ?.then((_) => onUpdated?.call());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  StringConstants.updateEmailText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            height15SizedBox,
            // Maybe Later -> dismiss
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Get.back();
                  onLater?.call();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  StringConstants.maybeLaterText,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

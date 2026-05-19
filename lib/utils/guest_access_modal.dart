import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/authentication/signup/view/signup_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Shows a modal dialog for guest users when they try to access restricted features
/// Provides three options: Login, Create Account, or Continue as Guest
class GuestAccessModal {
  static void show({
    String title = "Login Required",
    String message = "Please login to access this feature",
    VoidCallback? onContinueAsGuest,
  }) {
    Get.dialog(
      barrierDismissible: true,
      _GuestAccessDialog(
        title: title,
        message: message,
        onContinueAsGuest: onContinueAsGuest,
      ),
    );
  }
}

class _GuestAccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onContinueAsGuest;

  const _GuestAccessDialog({
    required this.title,
    required this.message,
    this.onContinueAsGuest,
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
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            height20SizedBox,
            // Title
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
            // Message
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
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => const LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  StringConstants.loginYourAccountText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            height15SizedBox,
            // Create Account Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => const SignupScreen());
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  StringConstants.createAccountText,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            height15SizedBox,
            // Continue as Guest Button
            if (onContinueAsGuest != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    onContinueAsGuest!();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continue as Guest",
                    style: TextStyle(
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

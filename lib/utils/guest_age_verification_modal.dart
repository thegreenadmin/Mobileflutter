import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Age gate shown once per session when a guest lands on the home screen.
/// "Yes" continues guest mode; "No" clears the guest session and returns to
/// the start journey screen where the user can pick another option.
class GuestAgeVerificationModal {
  static void show() {
    Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: const _GuestAgeVerificationDialog(),
      ),
    );
  }
}

class _GuestAgeVerificationDialog extends StatelessWidget {
  const _GuestAgeVerificationDialog();

  void _onYes() {
    guestAgeVerified.value = true;
    Get.back();
  }

  void _onNo() async {
    // Clear the guest session so the start journey screen is a clean slate.
    isGuest.value = false;
    guestAgeVerified.value = false;
    firstName.value = "";
    lastName.value = "";
    roleApp.value = "";
    await SharedPreferenceStorage.removeData(Role.role);
    Get.offAllNamed('/startJourneyScreen');
  }

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
                Icons.verified_user_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            height20SizedBox,
            const Text(
              "Age Verification",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            height10SizedBox,
            const Text(
              "You must be 18 years or older to browse The Green Mall. Are you 18 or older?",
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            height30SizedBox,
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onYes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Yes, I'm 18 or older",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            height15SizedBox,
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _onNo,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "No, I'm under 18",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

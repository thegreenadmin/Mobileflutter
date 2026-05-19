import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/authentication/signup/view/signup_screen.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/welcome/startjourney/controller/start_journey_controller.dart';

class StartJourneyScreen extends StatefulWidget {
  const StartJourneyScreen({super.key});

  @override
  State<StartJourneyScreen> createState() => _StartJourneyScreenState();
}

class _StartJourneyScreenState extends State<StartJourneyScreen> {
  final StartJourneyController startJourneyController =
      Get.put(StartJourneyController());

  void _browseAsGuest() async {
    print("DEBUG: _browseAsGuest called");
    // Set user as guest (session-only, not persisted)
    roleApp.value = Role.customerRoleText;
    isGuest.value = true;
    firstName.value = "Guest";
    lastName.value = "";
    print("DEBUG: Guest state set - isGuest: ${isGuest.value}, roleApp: ${roleApp.value}");

    // Navigate to home screen using named route
    print("DEBUG: Navigating to BottomNavigation");
    Get.offAllNamed('/bottomNavigation');
    print("DEBUG: Navigation called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            height: WidgetConstants.screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.startJourneyBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(
              children: [
                Image.asset(ImageConstants.greenmall420),
                height10SizedBox,
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    ImageConstants.fourTwenty,
                    scale: 3.5,
                  ),
                ),
              ],
            ),
          ),
          height350SizedBox,
          Positioned(
              left: 30,
              right: 30,
              bottom: 60,
              child: Column(
                children: [
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () {
                      Get.to(() => const LoginScreen());
                    },
                    height: 50,
                    text: StringConstants.loginYourAccountText,
                    borderRadius: 12,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    iconL: false,
                  ),
                  height20SizedBox,
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.white, AppColors.white],
                    ),
                    onTap: () {
                      Get.to(const SignupScreen(
                        isFromOwner: false,
                      ));
                    },
                    height: 50,
                    textColor: AppColors.primary,
                    text: StringConstants.createAnAccountText,
                    borderRadius: 12,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    iconL: false,
                  ),
                  height15SizedBox,
                  TextButton(
                    onPressed: () {
                      _browseAsGuest();
                    },
                    child: Text(
                      StringConstants.continueAsGuestText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  height15SizedBox,
                  InkWell(
                    onTap: () {
                      Get.to(
                        const SignupScreen(isFromOwner: true),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringConstants.ownAStoreText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          StringConstants.registerHereText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: AppColors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }
}

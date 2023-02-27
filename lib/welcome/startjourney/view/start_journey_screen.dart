import 'package:flutter/material.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/authentication/signup/view/signup_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/welcome/startjourney/controller/start_journey_controller.dart';

class StartJourneyScreen extends StatefulWidget {
  const StartJourneyScreen({super.key});

  @override
  State<StartJourneyScreen> createState() => _StartJourneyScreenState();
}

class _StartJourneyScreenState extends State<StartJourneyScreen> {
  final StartJourneyController startJourneyController =
      Get.put(StartJourneyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: WidgetConstants.screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/startJourneyBg.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/greenmall420.png"),
                height300SizedBox,
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    StringConstants.your420MarketPlace,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white),
                  ),
                ),
                height30SizedBox,
                CustomButton(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primary],
                  ),
                  onTap: () {
                    Get.to(const LoginScreen());
                  },
                  height: 50,
                  text: StringConstants.loginYourAccountText,
                  borderRadius: 12,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  icon: false,
                  image: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
                height20SizedBox,
                CustomButton(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.white, AppColors.white],
                  ),
                  onTap: () {
                    Get.to(const SignupScreen());
                  },
                  height: 50,
                  textColor: AppColors.primary,
                  text: StringConstants.createAnAccountText,
                  borderRadius: 12,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  icon: false,
                  image: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
                height30SizedBox,
                Row(
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
                )
              ],
            )),
      ),
    );
  }
}

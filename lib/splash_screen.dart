import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  startTime() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    // Get.to(() => const SignupScreen());
    // if (SharedPreferenceStorage.getData('userId') != null) {
    Get.offAll(() => const OnBoardMainScreen());
    //   debugPrint("I am in Dashboard");
    // } else {
    //   debugPrint("I am in register View");
    //   Get.offNamed('/registerView');
    // }
  }

  @override
  Widget build(BuildContext context) {
    startTime();
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/splashBg.png"),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}

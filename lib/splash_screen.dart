import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    // if (SharedPreferenceStorage.getData('token') != null) {
    //   Get.offAll(() => BottomNavigation());
    //   debugPrint("I am in Dashboard");
    // } else {
    //   debugPrint("I am in onboard View");
    Get.to(() => const OnBoardMainScreen());
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

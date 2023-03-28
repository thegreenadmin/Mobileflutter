import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    if (SharedPreferenceStorage.getData('token') != null) {
      Get.offAll(() => BottomNavigation());
    } else {
      Get.offNamed('/onboardView');
    }
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

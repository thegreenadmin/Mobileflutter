import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;

  // startTime() {
  //   var duration = const Duration(seconds: 2);
  //   return Timer(duration, navigationPage);
  // }
  startTime() async {
    BioMetricAuthentication.isBioMetricAuthenticated.value =
        await SharedPreferenceStorage.getData(StringConstants.authenticatedText.toLowerCase()) !=null
            ?SharedPreferenceStorage.getData(StringConstants.authenticatedText.toLowerCase()) as bool : false ??
            false;
    debugPrint(
        "BIOMETRIC AUTHENTICATION ******* ${BioMetricAuthentication.isBioMetricAuthenticated.value}");
    var duration = const Duration(seconds: 2);
    return Timer(
        duration,
        BioMetricAuthentication.isBioMetricAuthenticated.value == false
            ? navigationPage
            : _authenticateWithBiometrics);
  }

  Future<void> navigationPage() async {
    var token = await SharedPreferenceStorage.getData('token');

    if ( token!= null) {
      Get.offAll(() => const BottomNavigation());
    } else {
      Get.offNamed('/onboardView');
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorized = 'Authenticating';
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      isAuthenticating = false;
      authorized = 'Authenticating';
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      setState(() {
        isAuthenticating = false;
        authorized = 'Error - ${e.message}';
      });

      return;
    }
    if (!mounted) {
      return;
    }
    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    authorized = message;

    if (authenticated) {
      SharedPreferenceStorage.setData(
          StringConstants.authenticatedText.toLowerCase(), authenticated);
      await navigationPage();
    } else {
      _authenticateWithBiometrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    startTime();
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstants.splashBg),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}

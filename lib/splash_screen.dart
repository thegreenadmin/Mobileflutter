import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
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
  bool authh = false;

  startTime() async {
    // Future.delayed(const Duration(seconds: 1)).then((value) async {
    authh = await SharedPreferenceStorage.getData(
            StringConstants.authenticatedText) ??
        false;
    authenticatedBiometric.value = authh;
    debugPrint("BIOMETRIC AUTHENTICATION 123******* ${authh}");
    authh != null && authh != false ? authh : false;
    BioMetricAuthentication.isBioMetricAuthenticated.value = authh;
    // BioMetricAuthentication.isBioMetricAuthenticated
    //     .value = await SharedPreferenceStorage.getData(
    //             StringConstants.authenticatedText) !=
    //         null
    //     ? SharedPreferenceStorage.getData(StringConstants.authenticatedText)
    //         as bool
    //     : false;
    debugPrint(
        "BIOMETRIC AUTHENTICATION ******* ${BioMetricAuthentication.isBioMetricAuthenticated.value}");
    // });
    var duration = const Duration(seconds: 2);
    return Timer(
        duration,
        BioMetricAuthentication.isBioMetricAuthenticated.value == false
            ? navigationPage
            : _authenticateWithBiometrics);
  }

  Future<void> navigationPage() async {
    var role = await SharedPreferenceStorage.getData(Role.role);
    var token = await SharedPreferenceStorage.getData('token');
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      roleApp.value = role ?? "";
      if (token != null) {
        authToken.value = token;
        Get.offAll(() => const BottomNavigation());
      } else {
        Get.offNamed('/onboardView');
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    print("_authenticateWithBiometrics:***** called");
    bool authenticated = false;
    try {
      // setState(() {
      isAuthenticating = true;
      authorized = 'Authenticating';
      // });

      authenticatedBiometric.value = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      // setState(() {
      isAuthenticating = false;
      authorized = 'Authenticating';
      // });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      // setState(() {
      isAuthenticating = false;
      authorized = 'Error - ${e.message}';
      //});
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    //setState(() {
    authorized = message;
    //});
    print("authenticated:***************************************");
    print(authenticated);
    print(message);
    if (authenticatedBiometric.value) {
      print("authenticated:***00000000000*********");
      SharedPreferenceStorage.setData(
          StringConstants.authenticatedText, authenticated);

      await navigationPage();
    } else {
      print("no authenticated:***0111111111111 *******");
      _authenticateWithBiometrics();
    }
  }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     isAuthenticating = true;
  //     authorized = 'Authenticating';
  //     Future.delayed(const Duration(seconds: 2)).then((value) async {
  //       authenticated = await auth.authenticate(
  //         localizedReason: 'Scan your fingerprint to authenticate',
  //         options: const AuthenticationOptions(
  //           stickyAuth: true,
  //           biometricOnly: true,
  //         ),
  //       );
  //     });
  //    // isAuthenticating = false;
  //    // authorized = 'Authenticating';
  //   } on PlatformException catch (e) {
  //     debugPrint(e.toString());
  //     setState(() {
  //       isAuthenticating = false;
  //       authorized = 'Error - ${e.message}';
  //     });

  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }
  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';
  //   authorized = message;

  //   if (authenticated) {
  //     print("HELLO *****" + authenticated.toString());
  //     SharedPreferenceStorage.setData(
  //         StringConstants.authenticatedText, authenticated);
  //     await navigationPage();
  //   } else {
  //     _authenticateWithBiometrics();
  //   }
  // }

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

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver , GlobalVarMixin{
  final LocalAuthentication auth = LocalAuthentication();
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;
  bool authh = false;

  startTime() async {
    authh = await SharedPreferenceStorage.getData(
            StringConstants.authenticatedText) ??
        false;
    authenticatedBiometric.value = authh;
    authh != false ? authh : false;
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
    var duration = const Duration(seconds: 2);
    return Timer(
        duration,
        BioMetricAuthentication.isBioMetricAuthenticated.value == false
            ? navigationPage
            : _authenticateWithBiometrics);
  }

  Future<void> navigationPage() async {
    var role = await SharedPreferenceStorage.getData(Role.role);
    var token =
        await SharedPreferenceStorage.getData(StringConstants.tokenText);
    var onboardingCompleted =
        await SharedPreferenceStorage.getData("onboardingCompleted") ?? "";
    bool wasStoreOwner =
        await SharedPreferenceStorage.getData("isStoreOwner") ?? false;
    Future.delayed(const Duration(seconds: 3)).then((value) async {

      roleApp(role ?? "");
      // roleApp.value = role ?? "";

      if (onboardingCompleted == "yes") {
        Get.offAll(() => const StartJourneyScreen());
      } else if (token != null) {
        isStoreOwner.value = wasStoreOwner;
        authToken.value = token;
        Get.offAll(() => const BottomNavigation());
      } else {
        Get.offNamed('/onboardView');
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    debugPrint("_authenticateWithBiometrics:***** called");
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorized = 'Authenticating';
      authenticatedBiometric.value = await auth.authenticate(
        localizedReason: StringConstants.scanYourFingerPrintText,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      isAuthenticating = false;
      authorized = 'Authenticating';
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      debugPrint(e.message);
      isAuthenticating = false;
      authorized = 'Error - ${e.message}';
      if (Platform.isAndroid) {
        if (e.code == "LockedOut" || e.code == "NotAvailable") {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      } else {
        debugPrint("Platform.ios");
      }

      return;
    }
    if (!mounted) {
      return;
    }
    final String message =
        authenticatedBiometric.value ? 'Authorized' : 'Not Authorized';
    authorized = message;
    if (authenticatedBiometric.value) {
      SharedPreferenceStorage.setData(
          StringConstants.authenticatedText, authenticated);
      await navigationPage();
    } else {
      _authenticateWithBiometrics();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){

    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  void dispose() {
    super.dispose();
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

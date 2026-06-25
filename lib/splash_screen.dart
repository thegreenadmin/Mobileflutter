import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/push_notifications/device_token_service.dart';
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

  Timer? _timer;
  bool _started = false;
  int _bioRetryCount = 0;
  static const int _maxBioRetries = 3;

  startTime() async {
    authh = await SharedPreferenceStorage.getData(
            StringConstants.authenticatedText) ??
        false;
    authenticatedBiometric.value = authh;
    BioMetricAuthentication.isBioMetricAuthenticated.value = authh;
    // BioMetricAuthentication.isBioMetricAuthenticated
    //     .value = await SharedPreferenceStorage.getData(
    //             StringConstants.authenticatedText) !=
    //         null
    //     ? SharedPreferenceStorage.getData(StringConstants.authenticatedText)
    //         as bool
    //     : false;
    var duration = const Duration(seconds: 2);
    _timer = Timer(
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

      if (token != null) {
        isStoreOwner.value = wasStoreOwner;
        authToken.value = token;
        isGuest.value = false; // Ensure guest flag is false when token exists
        // Re-sync the FCM token: it may have rotated since the last login, in
        // which case the server is holding a dead token and push has stopped.
        DeviceTokenService.instance.syncToken();
        Get.offAll(() => const BottomNavigation());
      } else {
        // For new users or those without token, go to StartJourneyScreen
        // where they can choose to login, signup, or continue as guest
        Get.offAll(() => const StartJourneyScreen());
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
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
      isAuthenticating = false;
      authorized = 'Error - ${e.message}';
      if (Platform.isAndroid) {
        if (e.code == "LockedOut" || e.code == "NotAvailable") {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      } else {
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
      _bioRetryCount = 0;
      SharedPreferenceStorage.setData(
          StringConstants.authenticatedText, authenticatedBiometric.value);
      await navigationPage();
    } else if (_bioRetryCount < _maxBioRetries) {
      _bioRetryCount++;
      _authenticateWithBiometrics();
    } else {
      // Exhausted retries: stop looping so the user isn't trapped on splash.
      _bioRetryCount = 0;
      authorized = 'Not Authorized';
      if (Platform.isAndroid) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_started) {
      _started = true;
      startTime();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){

    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

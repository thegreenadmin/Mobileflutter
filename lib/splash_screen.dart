import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.detached.toString()) {
        logout();
      }
      return Future.value(null);
    });
    super.initState();
  }

  Future<void> logout() async {
    await apiLogOutUser();
  }

  ///logout user account
  Future apiLogOutUser() async {
    debugPrint(
        "LOGGED OUT USER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().logoutUser}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().logoutUser}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("LOGGED OUT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        clearData();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        clearData();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  clearData() async {
    SharedPreferenceStorage.clearData();
    Get.parameters.clear();
    await Get.offAll(const StartJourneyScreen());
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

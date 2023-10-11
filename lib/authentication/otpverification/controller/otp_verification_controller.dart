import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

import '../../../utils/global_share_data.dart';

class OtpVerificationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpTextController = TextEditingController();

  RxString phoneNumber = "".obs;
  RxString countryCode = "".obs;
  RxBool isLoading = false.obs;
  RxBool isSignUp = false.obs;
  RxBool isAutoReload = false.obs;
  RxBool autoValidate = false.obs;
  RxString? fcmToken = "".obs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments["phoneNumber"] ?? "";
    countryCode.value = Get.arguments["countryCode"] ?? "";
    isSignUp.value = Get.arguments["signUp"] ?? false;
  }

  getFcmToken() async {
    fcmToken!.value = (await messaging.getToken())!;

    debugPrint("FCM TOKEN *************$fcmToken");
  }

  bool otpValidateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  /// Fields Validation Method
  void validateAndSubmitOtp() async {
    if (otpValidateAndSave()) {
      try {
        await messaging.getToken().then((value) {
          fcmToken!.value = value ?? "";
          debugPrint("FCM TOKEN *************$fcmToken");
          apiOtpVerify();
        });
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  ///Otp Verify Api
  Future apiOtpVerify() async {
    isLoading.value = true;
    var rng = math.Random();
    Map data = {
      "phone": phoneNumber.value.trim(),
      "phone_code": countryCode.value.trim(),
      "otp": otpTextController.text.trim(),
      "device_id": rng.nextInt(100).toString(), //Random numbers
      "device_token": fcmToken!.value.trim(),
      "device_type": Platform.isAndroid
          ? StringConstants.gcmText
          : StringConstants.apnsText,
    };
    debugPrint("OTP VERIFY BODY********** $data");
    debugPrint(
        "OTP VERIFY URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().otpVerify}");
    UserProvider()
        .postApi(
            data, ServerCommunicator().baseUrl + ServerCommunicator().otpVerify,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OTP VERIFY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        otpTextController.clear();
        SharedPreferenceStorage.removeData("token");
        SharedPreferenceStorage.setData("pageId", 0);
        authToken.value = value.body['data']['token'];
        SharedPreferenceStorage.setData("token", value.body['data']['token']);
        hasStoreAccess.value = value.body['data']['has_store_access'] ?? false;
        if (hasStoreAccess.value) {
          forFirstTimeOwner.value = isSignUp.value;
          forFirstTimeCustomer.value = isSignUp.value;
          SharedPreferenceStorage.setData(Role.role, Role.storeOwnerRoleText);
          roleApp.value = Role.storeOwnerRoleText;
        } else {
          forFirstTimeCustomer.value = isSignUp.value;
          forFirstTimeOwner.value = false;
          SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
          roleApp.value = Role.customerRoleText;
        }
        Get.offAll(() => const BottomNavigation());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        // Email must be unique & user already exists
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///GET STORE PERMISSIONS
  Future apiGetPermissions() async {
    try {
      debugPrint(
          "GET STORE PERMISSIONS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storePermissionsList}");
      Map<String, String> headers = {
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
      };
      debugPrint("GET STORE PERMISSIONS TOKEN ********** $headers");
      UserProvider()
          .getWithHeadersApi(
              ServerCommunicator().baseUrl +
                  ServerCommunicator().storePermissionsList,
              headers,
              showLoading: false)
          .then((value) async {
        log("GET STORE PERMISSIONS RESPONSE *******${value?.body}");
        if (value?.body["status"] == ApiConstants.statusCode201 ||
            value?.body["status"] == ApiConstants.statusCode200) {
          getPermissionsModel = GetPermissionsModel.fromJson(value?.body);
          permissionStoreList.value = getPermissionsModel.data!.stores!;
        } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        } else {
          if (value?.body['message'] != null) {
            Utility.showAlertMessage(value?.body['message']);
          }
        }
      });
    } catch (e) {
      log("GET STORE PERMISSIONS ERROR*******${e.toString()}");
    }
  }
}

import 'dart:io';
import 'dart:math';

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

class OtpVerificationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpTextController = TextEditingController();

  RxString phoneNumber = "".obs;
  RxString countryCode = "".obs;
  RxBool autoValidate = false.obs;
  RxString? fcmToken = "".obs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxBool hasStoreAccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments["phoneNumber"] ?? "";
    countryCode.value = Get.arguments["countryCode"] ?? "";
    getFcmToken();
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

// Fields Validation Method
  void validateAndSubmitOtp() async {
    if (otpValidateAndSave()) {
      try {
        apiOtpVerify();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Otp Verify Api
  Future apiOtpVerify() async {
    var rng = Random();
    Map data = {
      "phone": phoneNumber.value.trim(),
      "phone_code": countryCode.value.trim(),
      "otp": otpTextController.text.trim(),
      "device_id": rng.nextInt(100).toString(), //Random numbers
      "device_token": fcmToken!.value.trim(),
      "device_type": Platform.isAndroid ? "GCM" : "APNS"
    };
    debugPrint("OTP VERIFY BODY********** $data");
    debugPrint(
        "OTP VERIFY URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().otpVerify}");
    UserProvider()
        .postApi(
            data, ServerCommunicator().baseUrl + ServerCommunicator().otpVerify,
            showLoading: true)
        .then((value) async {
      debugPrint("OTP VERIFY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        otpTextController.clear();
        SharedPreferenceStorage.removeData("token");
        SharedPreferenceStorage.setData("pageId", 0);
        SharedPreferenceStorage.setData("token", value.body['data']['token']);
        debugPrint("SharedPreferenceStorage: token: ------ ");
        var token = await SharedPreferenceStorage.getData("token");
        debugPrint(token.toString());


        hasStoreAccess.value = value.body['data']['has_store_access'] ?? false;
        if (hasStoreAccess.value) {
          SharedPreferenceStorage.setData(
              Role.role.value, Role.storeOwnerRoleText);
        } else {
          SharedPreferenceStorage.setData(
              Role.role.value, Role.customerRoleText);
        }

        Get.offAll(() => const BottomNavigation());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        //email must be unique & user already exists
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}

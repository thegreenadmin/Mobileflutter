import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_config_service.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

import '../../../utils/global_share_data.dart';

class OtpVerificationController extends GetxController  with GlobalVarMixin{
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
  Future<void> onInit() async {
    super.onInit();
    phoneNumber.value = Get.arguments["phoneNumber"] ?? "";
    countryCode.value = Get.arguments["countryCode"] ?? "";
    isSignUp.value = Get.arguments["signUp"] ?? false;
    await getFcmToken();
  }

  Future<void> getFcmToken() async {
    try {
      await messaging.getToken().then((v){
        fcmToken!.value = v!;
        if (fcmToken?.value != null) {
          // Save or use the token
        } else {
          // Handle null token case
          Utility.showAlertMessage("Unable to retrieve device token. Please try again.");
        }
      });

    } catch (e) {
      // Handle error gracefully
      Utility.showAlertMessage("Failed to get notification token. Please check your network or app permissions.");
    }
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
          apiOtpVerify();
        });
      } catch (_) {
        // Utility.showAlertMessage("Failed to get notification token. Please check your network or app permissions.");
      }
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
                UserProvider()
        .postApi(
            data, ServerCommunicator.baseUrl + ServerCommunicator.otpVerify,
            showLoading: false)
        .then((value) async {

              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        otpTextController.clear();
        SharedPreferenceStorage.removeData("token");
        SharedPreferenceStorage.setData("pageId", 0);
        authToken.value = value?.body['data']['token'];

        SharedPreferenceStorage.setData("token", value?.body['data']['token']);
        hasStoreAccess.value = value?.body['data']['has_store_access'] ?? false;
        isStoreOwner.value = true; // Hardcoded for testing
        SharedPreferenceStorage.setData("isStoreOwner", isStoreOwner.value);
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
        isGuest.value = false; // Clear guest flag after roleApp is set so ever(isGuest) fires with role already populated
        // Re-resolve feature flags with the session token (licensee status
        // is only known for authenticated users).
        AppConfigService.refresh();
        isLoading.value = false;
        Get.offAll(() => const BottomNavigation());
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        // Email must be unique & user already exists
                isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
      } else {
                isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Generate/Resend OTP Api
  Future apiResendOtp() async {
    isLoading.value = true;
    Map data = {
      "phone": phoneNumber.value.trim(),
      "phone_code": countryCode.value.trim()
    };
                UserProvider()
        .postApi(data,
            ServerCommunicator.baseUrl + ServerCommunicator.generateOtp,
            showLoading: false)
        .then((value) async {

              if (value?.body["status"] == ApiConstants.statusCode201) {
                isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        //User not exist
                isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);

      } else if (value?.body["status"] == ApiConstants.statusCode400) {
        //Phone Number is not valid
                isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
      } else {
                isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///GET STORE PERMISSIONS
  Future apiGetPermissions() async {
    try {
              Map<String, String> headers = {
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
      };
              UserProvider()
          .getWithHeadersApi(
              ServerCommunicator.baseUrl +
                  ServerCommunicator.storePermissionsList,
              headers,
              showLoading: false)
          .then((value) async {
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

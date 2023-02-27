import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/signup/view/otp_verification_screen.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();
  TextEditingController userNameTextController = TextEditingController();
  Rx<Locale> cL = const Locale("en", "IN").obs;
  RxString selectedCountryCode = "".obs;
  RxString selectedRegion = "".obs;
  RxString sessionId = ''.obs;
  RxString savedPhoneNumber = ''.obs;
  RxString userId = ''.obs;
  RxString token = ''.obs;
  RxInt profileCompleted = 0.obs;
  RxBool isUserExist = false.obs;
  RxString userProfilePic = ''.obs;
  RxString? fcmToken = "".obs;
  RxBool autoValidate = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {});
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        Get.to(const OtpVerificationScreen());
        // if (isconnected) {
        // ForgotPasswordMethod(emailController.text.toString());
        /* } else {
          showToastMsg(("Please check your internet connection"));
        }*/
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }
}

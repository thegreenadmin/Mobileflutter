import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/authentication/otpverification/view/otp_verification_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController dateTextController = TextEditingController();

  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;

  RxString phoneNumber = "".obs;
  RxString countryCode = "".obs;

  Rx<Locale> cL = const Locale("en", "IN").obs;

  RxBool isTermsAccepted = false.obs;
  late RxString dateOfEvent = "".obs;
  late RxString timeOfEvent = "".obs;
  var date = DateTime(2022, 5, 6);
  var today = DateTime.now();

  RxString selectedCountryCode = "".obs;
  RxString selectedRegion = "".obs;
  String? formattedDate;
  RxBool autoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFromOwner = false.obs;

  void ageAlertDailogue(
    context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Image.asset("assets/greenmall420.png"),
            height10SizedBox,
            Text(
              "${StringConstants.alertText}!",
              style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              AlertStringConstants.above18Text,
              style: TextStyle(
                  color: AppColors.blackLight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.okayText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.cancelText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  /// Method to check user above 18 or not!
  bool isAdultCheck(String dob) {
    final dateOfBirth = DateFormat("yyyy-MM-dd").parse(dob);
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(
      now.year - 18,
      now.month,
      now.day + 1, // add day to return true on birthday
    );
    return dateOfBirth.isBefore(eighteenYearsAgo);
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

  /// Fields Validation Method
  void validateAndSubmit({bool isFromOwner = false}) async {
    if (validateAndSave()) {
      SharedPreferenceStorage.setData(
          StringConstants.firstNameText, firstName.value.trim());
      SharedPreferenceStorage.setData(
          StringConstants.lastNameText, lastName.value.trim());
      if (email.value.trim().isNotEmpty) {
        SharedPreferenceStorage.setData(
            StringConstants.emailText, email.value.trim());
      }
      try {
        if (isTermsAccepted.value == false) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseEnterTermsAndConditions);
        } else {
          apiCreateUser(isFromOwner: isFromOwner);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  ///Create Account User Api
  Future apiCreateUser({bool isFromOwner = false}) async {
    isLoading.value = true;
    Map data = {
      "first_name": firstNameTextController.text.trim(),
      "last_name": lastNameTextController.text.trim(),
      "phone": phoneNumber.value.trim(),
      "phone_code": countryCode.value.trim(),
      "has_store_access": isFromOwner,
      "is_store_owner": isFromOwner,
    };

    // Only include email if provided
    if (emailTextController.text.trim().isNotEmpty) {
      data["email"] = emailTextController.text.trim();
    }

    // Only include dob if provided
    if (dateTextController.text.trim().isNotEmpty) {
      data["dob"] = dateTextController.text.trim();
    }

    UserProvider()
        .postApi(data,
            ServerCommunicator.baseUrl + ServerCommunicator.createUser,
            showLoading: false)
        .then((value) async {
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        isLoading.value = false;
        await apiGenerateOtp();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        //email must be unique & user already exists
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

  ///Login Api
  Future apiGenerateOtp() async {
    Map data = {"phone": phoneNumber.value, "phone_code": countryCode.value};
    UserProvider()
        .postApi(data,
            ServerCommunicator.baseUrl + ServerCommunicator.generateOtp,
            showLoading: false)
        .then((value) async {
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        phoneNumberTextController.clear();
        Utility.showToast(value?.body['message']);
        Get.to(() => const OtpVerificationScreen(), arguments: {
          "phoneNumber": phoneNumber.value.trim(),
          "countryCode": countryCode.value.trim(),
          "signUp": true
        });

        firstNameTextController.clear();
        lastNameTextController.clear();
        emailTextController.clear();
        dateTextController.clear();
        isTermsAccepted.value = false;
        isFromOwner.value = false;
        phoneNumberTextController.clear();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        //User not exist
        Utility.showAlertMessage(value?.body['message']);
      } else if (value?.body["status"] == ApiConstants.statusCode400) {
        //Phone Number is not valid
        Utility.showAlertMessage(value?.body['message']);
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/otpverification/view/otp_verification_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/countries_list.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/utility.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController phoneTextController = TextEditingController();
  RxString phoneNumber = "".obs;
  RxString countryCode = "".obs;

  Rx<Locale> cL = const Locale("en", "IN").obs;
  RxString selectedCountryCode = "".obs;
  RxString selectedRegion = "".obs;

  RxBool autoValidate = false.obs;
  RxList<String> countryCodes = <String>[].obs;


  getCountryCodes() {
    for (var element in countriesList) {
      countryCodes.add(element.code);
    }
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
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        apiGenerateOtp();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  ///Login Api
  Future apiGenerateOtp() async {
    Map data = {
      "phone": phoneNumber.value.trim(),
      "phone_code": countryCode.value.trim()
    };
    debugPrint("LOGIN BODY********** $data");
    debugPrint(
        "LOGIN URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().generateOtp}");
    UserProvider()
        .postApi(data,
            ServerCommunicator().baseUrl + ServerCommunicator().generateOtp,
            showLoading: true)
        .then((value) async {
      debugPrint("LOGIN RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201) {
        phoneTextController.clear();
        Utility.showToast(value?.body['message']);
        Get.parameters["isFromCartScreen"] = "true";
        Get.to(() => const OtpVerificationScreen(), arguments: {
          "phoneNumber": phoneNumber.value.trim(),
          "countryCode": countryCode.value.trim()
        });
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

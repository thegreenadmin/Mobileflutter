import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/otpverification/view/otp_verification_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
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

// Fields Validation Method
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        apiGenerateOtp();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Login Api
  Future apiGenerateOtp() async {
    Map data = {
      "phone": countryCode.value + phoneNumber.value,
    };
    debugPrint("LOGIN BODY********** $data");
    debugPrint(
        "LOGIN URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().generateOtp}");
    UserProvider()
        .postApi(data,
            ServerCommunicator().baseUrl + ServerCommunicator().generateOtp,
            showLoading: true)
        .then((value) async {
      debugPrint("LOGIN RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201) {
        phoneTextController.clear();
        Utility.showToast(value.body['message']);
        Get.to(() => const OtpVerificationScreen(),
            arguments: {"phoneNumber": countryCode.value + phoneNumber.value});
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        //User not exist
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode400) {
        //Phone Number is not valid
        Utility.showToast(value.body['message']);
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}

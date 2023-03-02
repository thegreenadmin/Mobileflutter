import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/authentication/otpverification/view/otp_verification_screen.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/utility.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController dateTextController = TextEditingController();
  TextEditingController timeTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();

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

  bool otpValidateAndSave() {
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
        if (dateTextController.text.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseSelectAge);
        } else if (isTermsAccepted.value == false) {
          Utility.showToast(AlertStringConstants.pleaseEnterTermsAndConditions);
        } else {
          apiCreateUser();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  void validateAndSubmitOtp() async {
    if (otpValidateAndSave()) {
      try {
        apiOtpVerify();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Create Account User
  Future apiCreateUser() async {
    Map data = {
      "first_name": firstNameTextController.text.trim(),
      "last_name": lastNameTextController.text.trim(),
      "email": emailTextController.text.trim(),
      "phone": countryCode.value + phoneNumber.value,
      "dob": dateTextController.text.trim()
    };
    debugPrint("CREATE USER BODY********** $data");
    debugPrint(
        "CREATE USER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createUser}");
    UserProvider()
        .postApi(data,
            ServerCommunicator().baseUrl + ServerCommunicator().createUser,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE USER RESPONSE *******${value!.body}");
      if (value.body["status"] == 201) {
        countryCode.value = "";
        phoneNumber.value = "";
        firstNameTextController.clear();
        lastNameTextController.clear();
        emailTextController.clear();
        dateTextController.clear();
        isTermsAccepted.value = false;
        phoneNumberTextController.clear();
        Utility.showMessage(StringConstants.successText, value.body['message']);
        Get.back();
        Get.to(const LoginScreen());
      } else if (value.body["status"] == 409) {
        //email must be unique & user already exists
        Utility.showMessage(StringConstants.alertText, value.body['message']);
      } else {
        Utility.showMessage(
            StringConstants.alertText, value.body['message'].toString());
      }
    });
  }

  //Otp Verify Api
  Future apiOtpVerify() async {
    Map data = {
      "phone": "+918288033489",
      "otp": otpTextController.text.trim(),
      "device_id": "1234567",
      "device_token": "1234567"
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
      if (value.body["status"] == 201) {
        Utility.showMessage(StringConstants.successText, value.body['message']);
        otpTextController.clear();
        Get.offAll(() => BottomNavigation());
      } else if (value.body["status"] == 409) {
        //email must be unique & user already exists
        Utility.showMessage(StringConstants.alertText, value.body['message']);
      } else {
        Utility.showMessage(
            StringConstants.alertText, value.body['message'].toString());
      }
    });
  }
}

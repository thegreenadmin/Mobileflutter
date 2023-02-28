import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/authentication/signup/view/otp_verification_screen.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  TextEditingController dateTextController = TextEditingController();
  TextEditingController timeTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();
  Rx<Locale> cL = const Locale("en", "IN").obs;
  RxBool obscureText = true.obs;
  RxBool obscureTextConfirmPass = true.obs;
  RxBool isTermsAccepted = false.obs;
  late RxString dateOfEvent = "".obs;
  late RxString timeOfEvent = "".obs;
  var date = DateTime(2022, 5, 6);
  var today = DateTime.now();

  RxString selectedCountryCode = "".obs;
  RxString selectedRegion = "".obs;
  String? formattedDate;
  RxBool autoValidate = false.obs;

  void toggle() {
    obscureText.value = !obscureText.value;
    update();
  }

  void toggleConfirmPass() {
    obscureTextConfirmPass.value = !obscureTextConfirmPass.value;
    update();
  }

  bool isAdultCheck(String dob) {
    final dateOfBirth = DateFormat("MM/dd/yyyy").parse(dob);
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
          Get.to(BottomNavigation());
          //Get.to(const OtpVerificationScreen());
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  void validateAndSubmitOtp() async {
    if (otpValidateAndSave()) {
      try {
        Get.off(BottomNavigation());
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  // //Signup Api
  // Future apiSignup() async {
  //   if (nameTextController.text.trim().isEmpty) {
  //     Utility.showMessage("Alert", "Enter name");
  //   }
  //   if (emailTextController.text.trim().isEmpty) {
  //     Utility.showMessage("Alert", "Enter email");
  //   } else if (!GetUtils.isEmail(emailTextController.text.trim())) {
  //     Utility.showMessage("Alert", "Enter valid email ");
  //   } else if (passwordTextController.text.trim().isEmpty) {
  //     Utility.showMessage("Alert", "Enter password");
  //   } else if (passwordTextController.text.trim().length < 6) {
  //     Utility.showMessage("Alert", "Password must consist of 6 characters");
  //   } else if (confirmPasswordTextController.text.trim().isEmpty) {
  //     Utility.showMessage("Alert", "Enter confirm password");
  //   } else if (passwordTextController.text.trim() != confirmPasswordTextController.text.trim()) {
  //     Utility.showMessage("Alert", "Confirm password doesn't match");
  //   } else if (!isTermsAccepted.value) {
  //     Utility.showMessage("Alert", "Please accept Terms and Privacy policy");
  //   } else {
  //     Map data = {
  //       "name": nameTextController.text.trim(),
  //       "email": emailTextController.text.trim(),
  //       "password": passwordTextController.text.trim(),
  //     };
  //     debugPrint("SIGNUP BODY********** $data");
  //     debugPrint("SIGNUP URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().signupUrl}");
  //     UserProvider()
  //         .postApi(data, ServerCommunicator().baseUrl + ServerCommunicator().signupUrl, showLoading: true)
  //         .then((value) async {
  //       if (value != null) {
  //         if (value.body["code"] == 200 && value.body["status"] == "success") {
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setString('token', value.body['result']['token'].toString());
  //           const storage = FlutterSecureStorage();
  //           await storage.write(key: 'token', value: value.body['result']['token'].toString());
  //           emailTextController.clear();
  //           passwordTextController.clear();
  //           confirmPasswordTextController.clear();
  //           Get.to(() => const ConnectWearables(isFromProfile: false));
  //         } else if (value.body["code"] == 400 && value.body["error"] == "error") {
  //           Utility.showMessage("Alert", value.body['message']);
  //         } else if (value.body["code"] == 404 && value.body["error"] == "error") {
  //           Utility.showMessage("Alert", value.body['message']);
  //         } else {
  //           Utility.showMessage("Alert", value.body['message'].toString());
  //         }
  //       }
  //     });
  //   }
  // }
}

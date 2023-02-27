import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/signup/view/otp_verification_screen.dart';

class ContactUsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController subjectTextController = TextEditingController();
  TextEditingController messageTextController = TextEditingController();

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
      try {} catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }
}

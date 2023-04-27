import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

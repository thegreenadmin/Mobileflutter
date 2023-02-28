import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/server_communicator.dart';

class Utility {
  static void showMessage(String title, String message) {
    Get.snackbar(title, message,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.white,
        backgroundColor: AppColors.primary);
  }

  static void showTopMessage(String title, String message) {
    Get.snackbar(title, message,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.primary);
  }

  static void showToast(dynamic message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
        fontSize: 14.0);
  }

  static void showSuccessMessage(String title, String message) {
    Get.snackbar(title, message,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM);
  }

  static String loadImageUrl(String url) {
    return ServerCommunicator().baseUrlWithoutV1 + url;
  }

  static showAlert(
    String title,
    String message,
    String buttonText,
  ) async {
    return await Get.dialog(AlertDialog(
      title: const Text(
        "Alert!",
        style: TextStyle(color: AppColors.primary, fontSize: 20),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 18,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              child: Text(buttonText),
              onPressed: () => Get.back(result: true),
              // ** result: returns this value up the call stack **
            ),
          ],
        ),
      ],
    ));
  }
}

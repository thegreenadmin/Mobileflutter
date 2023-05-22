import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class Utility {
  static void showMessage(String title, String message) {
    Get.snackbar(title, message,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
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
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
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


  static  void showConfirmAlertMessage(title, {
    String description = "", String? cancelText , String? okay ,
    Function()? okayTap, Function()? cancelTap }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height10SizedBox,
              Center(
                child: Image.asset(
                  ImageConstants.info,
                  color: AppColors.red,
                  scale: 1.5,
                ),
              ),
             /* height12SizedBox,
              Text(
                title,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),*/
              height15SizedBox,
              Text(
                title,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              height25SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: ()  {
                      cancelTap ??  Navigator.pop(_);
                    },
                    child: Container(
                      height: 50.0,
                      width: WidgetConstants.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          cancelText ?? StringConstants.cancelText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                     okayTap!() ??  Navigator.pop(_);
                      // Get.back();
                      // await apiPlaceOrder(context);
                    },
                    child: Container(
                      height: 50.0,
                      width: WidgetConstants.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          okay ?? StringConstants.okayText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: const <Widget>[],
      ),
    );
  }


  static  void showAlertMessage(description, {
    String? title, String? cancelText , String? okay ,void Function()? okayTap,void Function()? cancelTap }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            height10SizedBox,
            Image.asset(
              ImageConstants.info,
              color: AppColors.red,
              scale: 1.5,
            ),
            height12SizedBox,
            Visibility(
              visible: title!=null,
              child: Text(
                title ??"",
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            ),
            title!=null?
            height15SizedBox:height0SizedBox,
            Text(
              description??"",
              style: TextStyle(
                  color: AppColors.blacklight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            height25SizedBox,
            InkWell(
              onTap: () {
               okayTap ??  Navigator.pop(_);
                // Get.back();
                // await apiPlaceOrder(context);
              },
              child: Container(
                height: 50.0,
                width: WidgetConstants.screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    okay ?? StringConstants.okayText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  static showAlert(
    String title,
    String message,
    String buttonText,
  ) async {
    return await Get.dialog(AlertDialog(
      title: Text(
        StringConstants.alertText,
        style: const TextStyle(color: AppColors.primary, fontSize: 20),
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

  static String parseDateTime(DateTime timestamp,
      {String format = 'MMM d, h:mm a', required String secFormat}) {
    final dateTime = timestamp.toLocal();
    return DateFormat(format).format(dateTime).toString();
  }

  static String formatDateTime(String timestamp,
      {String firstFormat = 'MMM d, h:mm a',
      secFormat = 'yyyy-MM-dd hh:mm:ss'}) {
    DateTime parseDate = DateFormat(firstFormat).parse(timestamp.toString());
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat(secFormat);
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static Future<Position> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  static alertDialog(context,
      {String title = "",
      String description = "",
      String ok = "",
      String cancel = "",
      Function()? onOk,
      void Function()? onCancel}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 20),
          ),
          content: Text(description,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  fontSize: 20)),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  onOk ?? Get.back();
                },
                child: Text(ok)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                onCancel ?? Get.back();
              },
              child: Text(cancel),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSelectionMediaDialog(BuildContext context,
      {void Function()? onGalleryClick, void Function()? onCameraClick}) {
    return showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
              icon: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(_context);
                  },
                  child: const Icon(
                    Icons.clear,
                    color: AppColors.primary,
                    size: 24.0,
                  ),
                ),
              ),
              title: Text(
                StringConstants.fromWherePhotoText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_sharp,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          Text(StringConstants.galleryText,
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Navigator.pop(_context);
                        onGalleryClick!();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          Text(StringConstants.cameraText,
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Navigator.pop(_context);
                        onCameraClick!();
                      },
                    )
                  ],
                ),
              ));
        });
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

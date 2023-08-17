import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/utility.dart';

class UserProvider extends GetConnect {
  Future<Response?> getWithHeadersApi(String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.get(Uri.parse(url), headers: headers);
      if (showLoading) Get.back();
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      debugPrint("Alert:------");
      debugPrint(e.toString());
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

  Future<Response?> postApi(Map data, String url,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.post(Uri.parse(url),
          body: json.encode(data),
          headers: {"Content-Type": "application/json"});
      if (showLoading) Get.back();
      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

  // Signup request
  Future<Response?> putApi(Map data, String url,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.put(Uri.parse(url));

      if (showLoading) Get.back();
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

  // Post with header request
  Future<Response?> postWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.post(Uri.parse(url),
          body: jsonEncode(data), headers: headers);

      if (showLoading) Get.back();
      final mData = json.decode(res.body) as Map<dynamic, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }

      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      // Utility.showAlertMessage("FCM Error",title: );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      debugPrint(e.toString());
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

  // Post with header request
  Future<Response?> putWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.put(Uri.parse(url),
          body: json.encode(data), headers: headers);
      if (showLoading) Get.back();
      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        if (showLoading) Get.back();
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

  // Post with header request
  Future<Response?> putWithHeadersApi1(
      Map data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.put(Uri.parse(url),
          body: json.encode(data), headers: headers);
      if (showLoading) Get.back();
      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

  // Post with header request
  Future<Response?> deleteWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      });
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      final res = await ioClient.delete(Uri.parse(url),
          body: jsonEncode(data), headers: headers);

      if (showLoading) Get.back();
      final mData = json.decode(res.body) as Map<dynamic, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    } on SocketException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    } on TimeoutException {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        "Connection timed out.",
        title: "Alert!",
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      Utility.showAlertMessage(
        e.toString(),
        title: "Alert!",
      );
      return null;
    }
  }

// Chat Socket
  GetSocket userMessages(String url) {
    return socket(url);
  }

  Future<Response> updateAvatar(List<int> img, String filename) async {
    final avatar = MultipartFile(img, filename: filename);
    return post(
      '/upload',
      FormData({'avatar': avatar}),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class UserProvider extends GetConnect {

  Future<Response?> getWithHeadersApi(String url, Map<String, String> headers,
      {bool showLoading = false}) async
  {
    headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');

    log("API URL********** $url");
    log("API METHOD********** GET getWithHeadersApi");
    log("API headers********** $headers");
// ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.get(Uri.parse(url), headers: headers);
      if (showLoading) Get.back();


      log("API res.statusCode********** ${res.statusCode}");
      log("API Response********** ${res.body}");
      log("API Response********** ${json.decode(res.body)}");
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );

      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } finally {
      ioClient.close();
      httpClient.close(force: true);
    }
  }

  Future<Response?> postApi(Map data, String url, {bool showLoading = false}) async {
    log("API URL********** $url");
    log("API METHOD********** POST postApi");
    log("API data ********** ${json.encode(data)}");
// ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.post(Uri.parse(url),
          body: json.encode(data),
          headers: {"Content-Type": "application/json"});
      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }

      log("API Response********** ${json.decode(res.body)}");
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );

      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    }finally {
        ioClient.close();
        httpClient.close(force: true);
      }
  }

  // Signup request
  Future<Response?> putApi(Map data, String url,
      {bool showLoading = false}) async
  {
    log("API URL********** $url");
    log("API data ********** $data");
    log("API METHOD********** PUT");

    // ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
    
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.put(Uri.parse(url));

      if (showLoading) Get.back();

      log("API Response********** ${json.decode(res.body)}");
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );

      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } finally {
        ioClient.close();
        httpClient.close(force: true);
      }
  }

  // Post with header request
  Future<Response?> postWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {

    headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    log("API URL********** $url");
    log("API headers ********** $headers");
    log("API data ********** $data");
    log("API METHOD********** POST postWithHeadersApi");
// ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.post(Uri.parse(url),
          body: jsonEncode(data), headers: headers);

      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<dynamic, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      log("API Response********** ${json.decode(res.body)}");
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );

      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } finally {
        ioClient.close();
        httpClient.close(force: true);
      }
  }

  // Post with header request
  Future<Response?> putWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    log("API URL********** $url");
    log("API data ********** $data");
    log("API data ********** $headers");
    log("API METHOD********** PUT putWithHeadersApi");
// ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.put(Uri.parse(url),
          body: json.encode(data), headers: headers);
      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        if (showLoading) Get.back();
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      log("API Response********** ${json.decode(res.body)}");
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );

      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    }finally {
        ioClient.close();
        httpClient.close(force: true);
      }
  }

  // Post with header request
  Future<Response?> putWithHeadersApi1(
      Map data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    log("API URL********** $url");
    log("API data ********** $data");
    log("API data ********** $headers");
    log("API METHOD********** PUT putWithHeadersApi1");
// ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.put(Uri.parse(url),
          body: json.encode(data), headers: headers);
      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      } log("API Response********** ${json.decode(res.body)}");
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );

      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } finally {
      ioClient.close();
      httpClient.close(force: true);
    }
  }

  // Post with header request
  Future<Response?> deleteWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    log("API URL********** $url");
    log("API data ********** $data");
    log("API data ********** $headers");
    log("API METHOD********** DELETE deleteWithHeadersApi");
// ✅ Check Internet Before Proceeding
    var connectivityResult = await Connectivity().checkConnectivity();
    if ( connectivityResult.contains(ConnectivityResult.none)) {
      Utility.showAlertMessage(
        "Please check your network connection.",
        title: "No Internet Connection!",
      );
      return null;
    }
        if (showLoading) {
          Get.dialog(
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              barrierDismissible: false);
        }

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);
      try {
      final res = await ioClient.delete(Uri.parse(url),
          body: jsonEncode(data), headers: headers);

      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<dynamic, dynamic>;
      if (mData["multicast_id"] != null) {
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      } log("API Response********** ${json.decode(res.body)}");
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
    }  on TimeoutException {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } catch (e) {
      if (showLoading) Get.back();

        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );

      return null;
    } finally {
      ioClient.close();
      httpClient.close(force: true);
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

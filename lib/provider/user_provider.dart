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
import 'package:thegreenmall/utils/app_logger.dart';

class UserProvider extends GetConnect {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

  static final IOClient _ioClient = IOClient(_httpClient);


  static void disposeClient() {
    _ioClient.close();
    _httpClient.close(force: true);
  }

  Future<Response?> getWithHeadersApi(String url, Map<String, String> headers,
      {bool showLoading = false}) async
  {
    headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');

    AppLogger.logApiRequest('GET', url, {'headers': headers});
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
      /*HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);*/
      try {
      final res = await _ioClient.get(Uri.parse(url), headers: headers)  .timeout(const Duration(seconds: 30));
      if (showLoading) Get.back();

      AppLogger.logApiResponse('GET', url, res.statusCode, json.decode(res.body));
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
      Utility.showAlertMessage(
        "Connection timed out.",
        title:  AlertStringConstants.alertText,
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in getWithHeadersApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in getWithHeadersApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    }
  }

  Future<Response?> postApi(Map data, String url, {bool showLoading = false}) async {
    AppLogger.logApiRequest('POST', url, Map<String, dynamic>.from(data));
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

      /*HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);*/
      try {
      final res = await _ioClient.post(Uri.parse(url),
          body: json.encode(data),
          headers: {"Content-Type": "application/json"})  .timeout(const Duration(seconds: 30));
      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        AppLogger.error('FCM Error');
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }

      AppLogger.logApiResponse('POST', url, res.statusCode, json.decode(res.body));
      return Response(statusCode: res.statusCode, body: json.decode(res.body));
    } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
      Utility.showAlertMessage(
        "Connection timed out.",
        title:  AlertStringConstants.alertText,
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in postApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in postApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    }
  }

  // Signup request
  Future<Response?> putApi(Map data, String url,
      {bool showLoading = false}) async
  {
    AppLogger.logApiRequest('PUT', url, Map<String, dynamic>.from(data));

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

      /*HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);*/
      try {
        final res = await _ioClient.put(Uri.parse(url)).timeout(const Duration(seconds: 30));

        if (showLoading) Get.back();

        AppLogger.logApiResponse('PUT', url, res.statusCode, json.decode(res.body));
        return Response(statusCode: res.statusCode, body: json.decode(res.body));
      } on SocketException catch (e) {
        if (showLoading) Get.back();
        AppLogger.error('Server error', error: e);
        Utility.showAlertMessage(
          "Server error",
          title:  AlertStringConstants.alertText,
        );
        return null;
    } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
      Utility.showAlertMessage(
        "Connection timed out.",
        title:  AlertStringConstants.alertText,
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in putApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in putApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    }
  }

  // Post with header request
  Future<Response?> postWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {


    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    AppLogger.logApiRequest('POST (with headers)', url, {'headers': headers, 'data': Map<String, dynamic>.from(data)});
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

     /* HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(httpClient);*/
      try {
      final res = await _ioClient.post(Uri.parse(url),
          body: jsonEncode(data), headers: headers)  .timeout(const Duration(seconds: 30));

      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<dynamic, dynamic>;
      if (mData["multicast_id"] != null) {
        AppLogger.error('FCM Error');
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      AppLogger.logApiResponse('POST (with headers)', url, res.statusCode, json.decode(res.body));
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
      } on SocketException catch (e) {
        if (showLoading) Get.back();
        AppLogger.error('Server error', error: e);
        Utility.showAlertMessage(
          "Server error",
          title:  AlertStringConstants.alertText,
        );
        return null;
    } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
      Utility.showAlertMessage(
        "Connection timed out.",
        title:  AlertStringConstants.alertText,
      );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in postWithHeadersApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in postWithHeadersApi', error: e);
      Utility.showAlertMessage(
        e.toString(),
        title:  AlertStringConstants.alertText,
      );
      return null;
    }
  }

  // Post with header request
  Future<Response?> putWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {

    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    AppLogger.logApiRequest('PUT (with headers)', url, {'headers': headers, 'data': Map<String, dynamic>.from(data)});
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

      try {
      final res = await _ioClient.put(Uri.parse(url),
          body: json.encode(data), headers: headers)  .timeout(const Duration(seconds: 30));
      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        if (showLoading) Get.back();
        AppLogger.error('FCM Error');
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      AppLogger.logApiResponse('PUT (with headers)', url, res.statusCode, json.decode(res.body));
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
      } on SocketException catch (e) {
        if (showLoading) Get.back();
        AppLogger.error('Server error', error: e);
        Utility.showAlertMessage(
          "Server error",
          title:  AlertStringConstants.alertText,
        );
        return null;
      } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in putWithHeadersApi', error: e);
        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in putWithHeadersApi', error: e);
        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );
      return null;
    }
  }

  // Post with header request
  Future<Response?> putWithHeadersApi1(
      Map data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {

    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    AppLogger.logApiRequest('PUT (with headers 1)', url, {'headers': headers, 'data': Map<String, dynamic>.from(data)});
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


      try {
      final res = await _ioClient.put(Uri.parse(url),
          body: json.encode(data), headers: headers)  .timeout(const Duration(seconds: 30));
      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<String, dynamic>;
      if (mData["multicast_id"] != null) {
        AppLogger.error('FCM Error');
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      AppLogger.logApiResponse('PUT (with headers 1)', url, res.statusCode, json.decode(res.body));
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
      } on SocketException catch (e) {
        if (showLoading) Get.back();
        AppLogger.error('Server error', error: e);
        Utility.showAlertMessage(
          "Server error",
          title:  AlertStringConstants.alertText,
        );
        return null;
      } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in putWithHeadersApi1', error: e);
        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in putWithHeadersApi1', error: e);
        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );
      return null;
    }
  }

  // Post with header request
  Future<Response?> deleteWithHeadersApi(
      data, String url, Map<String, String> headers,
      {bool showLoading = false}) async {
    // headers.putIfAbsent('Connection', () => 'keep-alive');
    headers.putIfAbsent('Keep-Alive', () => 'timeout=5, max=1000');
    AppLogger.logApiRequest('DELETE (with headers)', url, {'headers': headers, 'data': Map<String, dynamic>.from(data)});
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

      try {
      final res = await _ioClient.delete(Uri.parse(url),
          body: jsonEncode(data), headers: headers).timeout(const Duration(seconds: 30));

      if (showLoading) Get.back();

      final mData = json.decode(res.body) as Map<dynamic, dynamic>;
      if (mData["multicast_id"] != null) {
        AppLogger.error('FCM Error');
        Utility.showAlertMessage("FCM Error", title: "Alert!");
        return null;
      }
      AppLogger.logApiResponse('DELETE (with headers)', url, res.statusCode, json.decode(res.body));
      return Response(
          statusCode: res.statusCode,
          body: json.decode(res.body),
          headers: headers);
      } on SocketException catch (e) {
        if (showLoading) Get.back();
        AppLogger.error('Server error', error: e);
        Utility.showAlertMessage(
          "Server error",
          title:  AlertStringConstants.alertText,
        );
        return null;
      } on TimeoutException catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Connection timed out', error: e);
        Utility.showAlertMessage(
          "Connection timed out.",
          title:  AlertStringConstants.alertText,
        );
      return null;
    } on Exception catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Exception in deleteWithHeadersApi', error: e);
        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );
      return null;
    } catch (e) {
      if (showLoading) Get.back();
      AppLogger.error('Error in deleteWithHeadersApi', error: e);
        Utility.showAlertMessage(
          e.toString(),
          title:  AlertStringConstants.alertText,
        );
      return null;
    }
  }

// Chat Socket
  GetSocket userMessages(String url) {
    return socket(url);
  }

  @override
  void onClose() {
    UserProvider.disposeClient();
    super.onClose();
  }

  Future<Response> updateAvatar(List<int> img, String filename) async {
    final avatar = MultipartFile(img, filename: filename);
    return post(
      '/upload',
      FormData({'avatar': avatar}),
    );
  }
}

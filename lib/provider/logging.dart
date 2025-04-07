// import 'dart:convert';
// import 'dart:developer';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart' as g;
// import 'package:flutter/foundation.dart';
//
// import '../utils/utility.dart';
// import 'err_response_model.dart';
//
// class Logging extends Interceptor {
//   @override
//   Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     // Check for internet connectivity
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       Utility.showAlertMessage(
//         "Connection Error",
//         title: "We are unable to reach the server at this time. Please try again later.",
//       );
//       handler.reject(
//         DioException(
//           requestOptions: options,
//           type: DioExceptionType.connectionError,
//           error: 'We are unable to reach the server at this time. Please try again later.',
//         ),
//       );
//       return;
//     }
//
//     // Add headers
//     options.headers["Accept"] = "application/json";
//     // options.headers["lang"] ??= CommonMethod().getLanguageCode();
//
//       // options.headers['Authorization'] =
//       // "Bearer ${CommonMethod().getUserData()?.authToken ?? StringConstants.emptyString}";
//
//
//     // Debug logs
//     if (kDebugMode) {
//       log('REQUEST[${options.method}] => PATH: ${options.path}');
//       // log('REQUEST[${"token"}] => token: ${CommonMethod().getUserData()?.authToken}');
//       log('REQUEST[${"headers"}] => headers: ${options.headers}');
//       log('REQUEST[${"queryParams"}] => query: ${options.queryParameters}');
//
//       // Safely log the data
//       log('REQUEST[${"data"}] => data: ${options.data}');
//
//     }
//
//     return handler.next(options);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if (kDebugMode) {
//       log('RESPONSE[${response.statusCode}] => data: ${jsonEncode(response.data)}');
//     }
//     return super.onResponse(response, handler);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 500) {
//       log('onError: ${err.response.toString()}');
//       // myLog(label: "onError", value: err.response.toString());
//       Utility.showAlertMessage(
//         "Error",
//         title: err.response?.data["message"],
//       );
//       // CommonMethod().showErrorSnack(err.response?.data["message"]);
//     } else if (err.response?.statusCode == 401) {
//       // g.Get.dialog(const UnAuthorizedDialog(), barrierDismissible: false);
//     } else if (err.response?.statusCode == 422 &&
//         err.response?.data["message"] != null) {
//       Utility.showAlertMessage(
//         "Error",
//         title: err.response?.data["message"],
//       );
//     } else {
//       if (err.response != null) {
//         if (err.response?.data is String) {
//           if (err.response?.data.toString().contains("<!doctype html>") == true) {
//             Utility.showAlertMessage(
//               "Connection Error",
//               title: "We are unable to reach the server at this time. Please try again later.",
//             );
//           } else {
//             var response =
//             ErrorResponseModel.fromJson(json.decode(err.response?.data));
//             // CommonMethod().showServerMessageSnack(
//             //     response.message, err.response?.statusCode);
//             Utility.showAlertMessage(
//               "Error: ${err.response?.statusCode}",
//               title: response.message,
//             );
//           }
//         } else {
//           var response = ErrorResponseModel.fromJson(err.response?.data);
//           Utility.showAlertMessage(
//             "Error: ${err.response?.statusCode}",
//             title: response.message,
//           );
//         }
//       } else {
//         Utility.showAlertMessage(
//           "Connection Error",
//           title: "We are unable to reach the server at this time. Please try again later.",
//         );
//       }
//     }
//
//     if (kDebugMode) {
//       log(
//         'ERROR[${err.response?.statusCode}] => error: $err ${err.response?.realUri.toString()}',
//       );
//     }
//
//     return super.onError(err, handler);
//   }
// }

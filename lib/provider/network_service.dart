import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() {
    return _instance;
  }

  NetworkService._internal();

  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isDialogShown = false;

  void startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none && !_isDialogShown) {
        _isDialogShown = true;

        Get.defaultDialog(
          title: "No Internet Connection!",
          middleText: "Please check your network connection.",
          textConfirm: "OK",
          onConfirm: () {
            _isDialogShown = false;
            Get.back();
          },
          barrierDismissible: false,
        );
      }
    });
  }

  void stopMonitoring() {
    _subscription.cancel();
  }
}

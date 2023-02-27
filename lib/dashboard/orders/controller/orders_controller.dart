import 'package:get/get.dart';

class OrdersController extends GetxController {
  RxList orderList = [
    "Click & Collect",
    "Happy Shop",
    "Ambrosia Store",
    "Click & Collect",
    "Happy Shop",
    "Ambrosia Store"
  ].obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {});
  }
}

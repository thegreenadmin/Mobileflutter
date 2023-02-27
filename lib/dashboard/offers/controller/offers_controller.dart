import 'package:get/get.dart';

class OffersController extends GetxController {
  RxList offersList = [
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

import 'package:get/get.dart';

class AccountController extends GetxController {
  RxBool isScreenLockNotify = false.obs;
  RxBool isInboxMessagesNotify = false.obs;
  RxBool isTippingNotify = false.obs;
  @override
  void onInit() {
    print("Hiee");
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {});
  }
}

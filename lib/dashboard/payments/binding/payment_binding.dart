import 'package:get/get.dart';

import '../controller/payment_controller.dart';

/// Keeps a single PaymentController alive across the scan -> pay flow.
class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
  }
}

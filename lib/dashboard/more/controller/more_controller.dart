import 'package:get/get.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

class MoreController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? role = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;

  @override
  void onInit() {
    super.onInit();
    firstName?.value = SharedPreferenceStorage.getData(StringConstants.firstNameText)??"";
    lastName?.value = SharedPreferenceStorage.getData(StringConstants.lastNameText)??"";
    role?.value = SharedPreferenceStorage.getData(Role.role.value)??"";
  }
}

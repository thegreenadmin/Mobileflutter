import 'package:get/get.dart';
import 'package:thegreenmall/utils/utils.dart';

class MoreController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? role = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxInt pageId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";
    //
    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
  }
}

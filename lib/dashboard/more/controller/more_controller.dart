import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class MoreController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? role = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxInt pageId = 0.obs;

  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters["isController"] != "no") {
      getData();
    }
  }

  getData() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";
    role?.value = roleApp.value;
  }
}

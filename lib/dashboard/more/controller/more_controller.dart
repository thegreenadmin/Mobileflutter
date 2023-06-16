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
  RxInt pageId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }
  getData()async{
    pageId.value =await SharedPreferenceStorage.getData("pageId");
    firstName?.value = await SharedPreferenceStorage.getData(StringConstants.firstNameText).toString()??"";
    lastName?.value = await SharedPreferenceStorage.getData(StringConstants.lastNameText).toString()??"";
    role?.value =await SharedPreferenceStorage.getData(Role.role.value).toString()??"";
  }
}

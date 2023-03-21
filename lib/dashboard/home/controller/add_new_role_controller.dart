import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_controller.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddNewRoleController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController roleNameTextController = TextEditingController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxInt controllerId = 0.obs;
  RxBool checkBoxValue = false.obs;
  RxBool isLoading = false.obs;

  GetStoreControllerModel getStoreControllerModel = GetStoreControllerModel();

  RxList<Modules> moduleList = <Modules>[].obs;

  RxList<Controllers> controllerList = <Controllers>[].obs;

  RxList<Map<String, dynamic>> controllerIdsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    apiGetControllers();
  }

  //Create Role Api
  Future apiCreateRole() async {
    Map data = {
      "store_id": storeId.value,
      "role_name": roleNameTextController.text.trim(),
      "permissions": controllerIdsList
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE ROLE BODY********** $data");
    debugPrint(
        "CREATE ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleCreate}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().storeRoleCreate,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.back();
        });
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Controllers Api
  Future apiGetControllers() async {
    isLoading.value = true;
    debugPrint(
        "GET STORE CONTROLLER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeControllerList}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeControllerList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE CONTROLLER RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getStoreControllerModel = GetStoreControllerModel.fromJson(value.body);
        moduleList.value = getStoreControllerModel.data!.modules!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}

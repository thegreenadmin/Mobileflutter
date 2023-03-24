import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_role_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_controller.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddNewRoleController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  TextEditingController roleNameTextController = TextEditingController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString roleId = "".obs;
  RxInt controllerId = 0.obs;
  RxBool checkBoxValue = false.obs;
  RxBool isLoading = false.obs;

  RxBool autoValidate = false.obs;
  RxBool autoValidateUpdate = false.obs;

  GetStoreControllerModel getStoreControllerModel = GetStoreControllerModel();
  RxList<Modules> moduleList = <Modules>[].obs;

  GetRoleListModel getRoleListModel = GetRoleListModel();
  RxList<StoreRoles> storeRoleList = <StoreRoles>[].obs;

  GetStoreDetailModel getStoreDetailModel = GetStoreDetailModel();
  RxList<Permissions> permissionList = <Permissions>[].obs;

  RxList<dynamic> selectedRoles = <dynamic>[].obs;

  RxList<Map<String, dynamic>> controllerIdsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    apiGetControllers();
    apiGetStoreRole();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (controllerIdsList.isEmpty) {
          Utility.showToast(
              AlertStringConstants.pleaseSelectAtleastOnePermissionText);
        } else {
          await apiCreateRole();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  bool validateAndSaveUpdate() {
    final forms = updateFormKey.currentState;
    if (forms!.validate()) {
      forms.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmitUpdate() async {
    if (validateAndSaveUpdate()) {
      try {
        await apiEditRole();
      } catch (_) {}
    } else {
      autoValidateUpdate.value = true;
    }
  }

  //Get Store Role List Api
  Future apiGetStoreRole() async {
    isLoading.value = true;
    debugPrint(
        "GET STORE ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleList}?store_id=${storeId.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE ROLE  RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getRoleListModel = GetRoleListModel.fromJson(value.body);
        storeRoleList.value = getRoleListModel.data!.storeRoles!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
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
            showLoading: true)
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

//Delete Store Role
  Future apiDeleteRole() async {
    debugPrint(
        "DELETE ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "store_id": int.parse(storeId.value),
      "role_id": int.parse(roleId.value)
    };
    debugPrint("DELETE ROLE  BODY ************* $data");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        await apiGetStoreRole();
      } else if (value.body["status"] == 409) {
        Utility.showToast(value.body['message']);
        await apiGetStoreRole();
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Get Store Role Detail
  Future apiGetStoreRoleDetail() async {
    isLoading.value = true;
    debugPrint(
        "GET ROLE DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleDetail}?store_id=${storeId.value}&role_id=${roleId.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleDetail}?store_id=${storeId.value}&role_id=${roleId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET ROLE DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getStoreDetailModel = GetStoreDetailModel.fromJson(value.body);
        permissionList.value = getStoreDetailModel.data!.role!.permissions!;

        roleNameTextController.text = getStoreDetailModel.data!.role!.roleName!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Edit Role Api
  Future apiEditRole() async {
    Map data = {
      "store_id": storeId.value,
      "role_id": roleId.value,
      "role_name": roleNameTextController.text.trim(),
      "permissions": selectedRoles
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("EDIT ROLE BODY********** $data");
    debugPrint(
        "EDIT ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleEdit}");
    UserProvider()
        .putWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().storeRoleEdit,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("EDIT ROLE RESPONSE *******${value!.body}");
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
}

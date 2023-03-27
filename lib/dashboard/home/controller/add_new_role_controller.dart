import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/create_role_request_model.dart';
import 'package:thegreenmall/dashboard/home/model/delete_role_request_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_role_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_controller.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
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
  RxList<Controllers> controllerList = <Controllers>[].obs;

  GetRoleListModel getRoleListModel = GetRoleListModel();
  RxList<StoreRoles> storeRoleList = <StoreRoles>[].obs;

  GetStoreDetailModel getStoreDetailModel = GetStoreDetailModel();
  RxList<Permission> permissionList = <Permission>[].obs;
  RxList<Permission> permissionListMerged = <Permission>[].obs;
  List<dynamic> selectedRoles = <dynamic>[];

  RxList<Map<String, dynamic>> controllerIdsList = <Map<String, dynamic>>[].obs;

  late DeleteRoleRequestModel deleteRoleRequestModel = DeleteRoleRequestModel();
  late CreateRoleRequestModel createRoleRequestModel = CreateRoleRequestModel();

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
          Utility.showToast(AlertStringConstants.pleaseSelectAtleastOnePermissionText);
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
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleList}?store_id=${storeId.value}", headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE ROLE  RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        getRoleListModel = GetRoleListModel.fromJson(value.body);
        storeRoleList.value = getRoleListModel.data!.storeRoles!;
      } else if (value.body["status"] == ApiConstants.statusCode403) {
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
    createRoleRequestModel.storeId = int.parse(storeId.value);
    createRoleRequestModel.roleName = roleNameTextController.text.trim();

    List<Permissions> permissionsList = <Permissions>[];

    for (int i = 0; i < controllerIdsList.length; i++) {
      permissionsList.add(Permissions(controllerId: int.parse(controllerIdsList[i]['controller_id'])));
    }
    createRoleRequestModel.permissions = permissionsList;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE ROLE BODY********** ${createRoleRequestModel.toJson()}");
    debugPrint("CREATE ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleCreate}");
    UserProvider()
        .postWithHeadersApi(
            createRoleRequestModel, ServerCommunicator().baseUrl + ServerCommunicator().storeRoleCreate, headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.back();
        });
      } else if (value.body["status"] == ApiConstants.statusCode403) {
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
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(ServerCommunicator().baseUrl + ServerCommunicator().storeControllerList, headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE CONTROLLER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        getStoreControllerModel = GetStoreControllerModel.fromJson(value.body);
        moduleList.value = getStoreControllerModel.data!.modules!;
        for (int i = 0; i < moduleList.length; i++) {
          controllerList.addAll(moduleList[i].controllers as Iterable<Controllers>);
        }
      } else if (value.body["status"] == ApiConstants.statusCode403) {
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
    debugPrint("DELETE ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    deleteRoleRequestModel.storeId = int.parse(storeId.value);
    deleteRoleRequestModel.roleId = int.parse(roleId.value);

    debugPrint("DELETE ROLE  BODY ************* ${getStoreDetailModel.toJson()}");
    UserProvider()
        .deleteWithHeadersApi(
            deleteRoleRequestModel, "${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleDelete}", headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetStoreRole();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showToast(value.body['message']);
        await apiGetStoreRole();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
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
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        getStoreDetailModel = GetStoreDetailModel.fromJson(value.body);
        permissionList.value = getStoreDetailModel.data!.role!.permissions!;
        roleNameTextController.text = getStoreDetailModel.data!.role!.roleName!;
        permissionListMerged.clear();
        for (int i = 0; i < controllerList.length; i++) {
          var indexIs = permissionList.indexWhere((p0) => p0.controllerId == controllerList[i].controllerId);
          if (indexIs == -1) {
            permissionListMerged.add(Permission(
                permissionId: "",
                controllerId: controllerList[i].controllerId,
                status: "deleted",
                isSelected: false,
                controller: Controller(
                    controllerName: controllerList[i].controllerName,
                    controllerKey: controllerList[i].controllerKey,
                    controllerDescription: controllerList[i].controllerDescription)));
          } else {
            permissionListMerged.add(permissionList[indexIs]);
          }
        }
      } else if (value.body["status"] == ApiConstants.statusCode403) {
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
    selectedRoles.clear();
    for (int i = 0; i < permissionListMerged.length; i++) {
      selectedRoles.add({
        "permission_id": permissionListMerged[i].permissionId,
        "controller_id": permissionListMerged[i].controllerId,
        "status": permissionListMerged[i].status
      });
    }
    Map data = {
      "store_id": storeId.value,
      "role_id": roleId.value,
      "role_name": roleNameTextController.text.trim(),
      "permissions": selectedRoles
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("EDIT ROLE BODY********** $data");
    debugPrint("EDIT ROLE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRoleEdit}");
    UserProvider()
        .putWithHeadersApi(data, ServerCommunicator().baseUrl + ServerCommunicator().storeRoleEdit, headers,
            showLoading: true)
        .then((value) async {
      debugPrint("EDIT ROLE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.back();
        });
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}

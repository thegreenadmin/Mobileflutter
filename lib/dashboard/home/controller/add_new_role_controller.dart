import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart' as strings;
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';


class AddNewRoleController extends GetxController with GlobalVarMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  TextEditingController roleNameTextController = TextEditingController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString roleId = "".obs;
  RxInt controllerId = 0.obs;
  RxInt pageId = 0.obs;
  RxBool checkBoxValue = false.obs;
  RxBool isLoading = false.obs;
  RxBool isEnabled = false.obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();
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

  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPage();
    });
  }

  getPage() async {
    firstName?.value = await SharedPreferenceStorage.getData(
            strings.StringConstants.firstNameText) ??
        "";
    lastName?.value = await SharedPreferenceStorage.getData(
            strings.StringConstants.lastNameText) ??
        "";

    var roleVal = await SharedPreferenceStorage.getData(strings.Role.role);
    role?.value = roleVal;
    storeId.value = Get.parameters["storeId"] ?? "";
    storeName.value = Get.parameters["storeName"] ?? "";
    await apiGetControllers();
    await apiGetStoreRole();
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
          isLoading.value = false;
          Utility.showAlertMessage(strings
              .AlertStringConstants.pleaseSelectAtLeastOnePermissionText);
        } else {
          isLoading.value = true;
          await apiCreateRole();
        }
      } catch (_) {}
    } else {
      isLoading.value = false;
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
      isLoading.value = false;
      autoValidateUpdate.value = true;
    }
  }

  ///Get Store Role List Api
  Future apiGetStoreRole() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeRoleList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getRoleListModel = GetRoleListModel.fromJson(value?.body);
        storeRoleList.value = getRoleListModel.data!.storeRoles!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Create Role Api
  Future apiCreateRole() async {
    isLoading.value = true;
    createRoleRequestModel.storeId = int.parse(storeId.value);
    createRoleRequestModel.roleName = roleNameTextController.text.trim();

    List<Permissions> permissionsList = <Permissions>[];

    for (int i = 0; i < controllerIdsList.length; i++) {
      permissionsList.add(Permissions(
          controllerId: int.parse(controllerIdsList[i]['controller_id'])));
    }
    createRoleRequestModel.permissions = permissionsList;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            createRoleRequestModel,
            ServerCommunicator.baseUrl + ServerCommunicator.storeRoleCreate,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);

        Get.back(id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Controllers Api
  Future apiGetControllers() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeControllerList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getStoreControllerModel = GetStoreControllerModel.fromJson(value?.body);
        moduleList.value = getStoreControllerModel.data!.modules!;
        for (int i = 0; i < moduleList.length; i++) {
          controllerList
              .addAll(moduleList[i].controllers as Iterable<Controllers>);
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Store Role
  Future apiDeleteRole() async {
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    deleteRoleRequestModel.storeId = int.parse(storeId.value);
    deleteRoleRequestModel.roleId = int.parse(roleId.value);

         UserProvider()
        .deleteWithHeadersApi(
            deleteRoleRequestModel,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeRoleDelete}",
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        await apiGetStoreRole();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value?.body['message']);
        await apiGetStoreRole();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();

        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Store Role Detail
  Future apiGetStoreRoleDetail() async {
    isLoading.value = true;
    isEnabled = false.obs;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeRoleDetail}?store_id=${storeId.value}&role_id=${roleId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getStoreDetailModel = GetStoreDetailModel.fromJson(value?.body);
        permissionList.value = getStoreDetailModel.data!.role!.permissions!;
        isEnabled.value =
            getStoreDetailModel.data!.role!.roleName! != "Store Worker" &&
                getStoreDetailModel.data!.role!.roleName! != "Store Manager";
        roleNameTextController.text = getStoreDetailModel.data!.role!.roleName!;
        permissionListMerged.clear();
        for (int i = 0; i < controllerList.length; i++) {
          var indexIs = permissionList.indexWhere(
              (p0) => p0.controllerId == controllerList[i].controllerId);
          if (indexIs == -1) {
            permissionListMerged.add(Permission(
                permissionId: "",
                controllerId: controllerList[i].controllerId,
                status: "deleted",
                isSelected: false,
                controller: Controller(
                    controllerName: controllerList[i].controllerName,
                    controllerKey: controllerList[i].controllerKey,
                    controllerDescription:
                        controllerList[i].controllerDescription)));
          } else {
            permissionListMerged.add(permissionList[indexIs]);
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Edit Role Api
  Future apiEditRole() async {
    isLoading.value = true;
    selectedRoles.clear();
    bool isEmptyList = true;
    for (int i = 0; i < permissionListMerged.length; i++) {
      if (permissionListMerged[i].status == "active") {
        isEmptyList = false;
      }
      selectedRoles.add({
        "permission_id": permissionListMerged[i].permissionId,
        "controller_id": permissionListMerged[i].controllerId,
        "status": permissionListMerged[i].status
      });
    }
    if (isEmptyList) {
      Utility.showAlertMessage(
          AlertStringConstants.pleaseSelectOnePermissionText);
      return;
    }
    Map data = {
      "store_id": storeId.value,
      "role_id": roleId.value,
      "role_name": roleNameTextController.text.trim(),
      "permissions": selectedRoles
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .putWithHeadersApi(
            data,
            ServerCommunicator.baseUrl + ServerCommunicator.storeRoleEdit,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);

        Get.back(id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}

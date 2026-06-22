import 'dart:convert';

import 'package:get/get.dart';


mixin GlobalVarMixin {
  RxString _roleApp = "".obs;
  RxBool _authenticatedBiometric = false.obs;
  RxBool _isFirstHomeClick = false.obs;
  RxBool _wasKilled = false.obs;
  RxString _firstName = "".obs;
  RxString _lastName = "".obs;
  RxString _authToken = "".obs;
  RxInt _pageIdApp = 0.obs;
  RxBool _hasStoreAccess = false.obs;
  RxBool _isStoreOwner = false.obs;
  RxBool _forFirstTimeCustomer = false.obs;
  RxBool _forFirstTimeOwner = false.obs;

  /*RxBool get authenticatedBiometric => _authenticatedBiometric;

  set authenticatedBiometric(RxBool value) {
    _authenticatedBiometric = value;
  }



  RxString get roleApp => _roleApp;

  set roleApp(RxString value) {
    _roleApp = value;
  }



  RxBool get isFirstHomeClick => _isFirstHomeClick;

  set isFirstHomeClick(RxBool value) {
    _isFirstHomeClick = value;
  }

  RxBool get wasKilled => _wasKilled;

  set wasKilled(RxBool value) {
    _wasKilled = value;
  }

  RxString get firstName => _firstName;

  set firstName(RxString value) {
    _firstName = value;
  }

  RxString get lastName => _lastName;

  set lastName(RxString value) {
    _lastName = value;
  }

  RxString get authToken => _authToken;

  set authToken(RxString value) {
    _authToken = value;
  }

  RxInt get pageIdApp => _pageIdApp;

  set pageIdApp(RxInt value) {
    _pageIdApp = value;
  }

  RxBool get hasStoreAccess => _hasStoreAccess;

  set hasStoreAccess(RxBool value) {
    _hasStoreAccess = value;
  }

  RxBool get isStoreOwner => _isStoreOwner;

  set isStoreOwner(RxBool value) {
    _isStoreOwner = value;
  }

  RxBool get forFirstTimeCustomer => _forFirstTimeCustomer;

  set forFirstTimeCustomer(RxBool value) {
    _forFirstTimeCustomer = value;
  }

  RxBool get forFirstTimeOwner => _forFirstTimeOwner;

  set forFirstTimeOwner(RxBool value) {
    _forFirstTimeOwner = value;
  }*/
  /*void updateRoleApp(String newValue) {
    roleApp = newValue; // Update the value
  }*/

}

class SharedDataController extends GetxController {



/*var roleApp = ''.obs; // Use .obs to make it observable

  void updateRoleApp(String newValue) {
    roleApp.value = newValue; // Update the value
  }*/
}

RxString roleApp = "".obs;
RxBool authenticatedBiometric = false.obs;
RxBool isFirstHomeClick = false.obs;
RxBool wasKilled = false.obs;
RxString firstName = "".obs;
RxString lastName = "".obs;
RxString authToken = "".obs;
RxInt pageIdApp = 0.obs;
RxBool hasStoreAccess = false.obs;
RxBool isStoreOwner = false.obs;
RxBool forFirstTimeCustomer = false.obs;
RxBool forFirstTimeOwner = false.obs;
RxBool isGuest = false.obs;
// Session-only: set true once the guest confirms they are 18+ on the home
// screen, so the age gate is shown only once per guest session.
RxBool guestAgeVerified = false.obs;

// Country feature gating, resolved server-side from call metadata via
// GET utils/app/config (refreshed on startup, login and app resume).
// Defaults match the backend's fail-closed policy for unresolved countries:
// herbs hidden, everything else available.
RxBool munchiesEnabled = true.obs;
RxBool herbsEnabled = false.obs;
RxBool paymentsEnabled = true.obs;
RxBool isHerbsLicensee = false.obs;
// When the caller's country has exactly one herbs store, the backend returns
// its id here so the Herbs pill deep-links straight to that store instead of
// the store search. Empty when there are 0 or many herbs stores (→ search).
RxString herbsStoreId = "".obs;
GetPermissionsModel getPermissionsModel = GetPermissionsModel();
RxList<PermissionStore> permissionStoreList = <PermissionStore>[].obs;


enum PermissionKey {
  manageTransaction,
  editStore,
  deleteStore,
  managePages,
  createUser,
  viewStoreUsers,
  editStoreUsers,
  assignDesignationUser,
  editDesignation,
  createProductCategories,
  editProductCategories,
  createProduct,
  editProduct,
  createOffers,
  editOffers,
  manageOrders,
  manageReturnRequests,
  manageMessages,
}

extension StatusExtension on PermissionKey {
  String get statusName {
    switch (this) {
      case PermissionKey.manageTransaction:
        return 'MANAGE_TRANSACTION';
      case PermissionKey.editStore:
        return 'EDIT_STORE';
      case PermissionKey.deleteStore:
        return 'DELETE_STORE';
      case PermissionKey.managePages:
        return 'MANAGE_PAGE';
      case PermissionKey.createUser:
        return 'CREATE_STORE_USER';
      case PermissionKey.viewStoreUsers:
        return 'VIEW_STORE_USERS';
      case PermissionKey.editStoreUsers:
        return 'EDIT_STORE_USER';
      case PermissionKey.assignDesignationUser:
        return 'ASSIGN_DESIGNATION_TO_USER';
      case PermissionKey.editDesignation:
        return 'EDIT_ROLE';
      case PermissionKey.createProductCategories:
        return 'CREATE_CATEGORY';
      case PermissionKey.editProductCategories:
        return 'EDIT_CATEGORY';
      case PermissionKey.createProduct:
        return 'CREATE_PRODUCT';
      case PermissionKey.editProduct:
        return 'EDIT_PRODUCT';
      case PermissionKey.createOffers:
        return 'CREATE_OFFER';
      case PermissionKey.editOffers:
        return 'EDIT_OFFER';
      case PermissionKey.manageOrders:
        return 'MANAGE_ORDER';
      case PermissionKey.manageReturnRequests:
        return 'MANAGE_RETURN_ORDER';
      case PermissionKey.manageMessages:
        return 'MANAGE_MESSAGE';
      default:
        return 'MANAGE_TRANSACTION';
    }
  }
}

GetPermissionsModel getPermissionsModelFromJson(String str) =>
    GetPermissionsModel.fromJson(json.decode(str));

String getPermissionsModelToJson(GetPermissionsModel data) =>
    json.encode(data.toJson());

class GetPermissionsModel {
  int? status;
  String? message;
  PermissionData? data;

  GetPermissionsModel({
    this.status,
    this.message,
    this.data,
  });

  GetPermissionsModel copyWith({
    int? status,
    String? message,
    PermissionData? data,
  }) =>
      GetPermissionsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetPermissionsModel.fromJson(Map<String, dynamic> json) =>
      GetPermissionsModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : PermissionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class PermissionData {
  List<PermissionStore>? stores;

  PermissionData({
    this.stores,
  });

  PermissionData copyWith({
    List<PermissionStore>? stores,
  }) =>
      PermissionData(
        stores: stores ?? this.stores,
      );

  factory PermissionData.fromJson(Map<String, dynamic> json) => PermissionData(
        stores: json["stores"] == null
            ? []
            : List<PermissionStore>.from(
                json["stores"]!.map((x) => PermissionStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stores": stores == null
            ? []
            : List<dynamic>.from(stores!.map((x) => x.toJson())),
      };
}

class PermissionStore {
  String? storeId;
  String? storeName;
  bool? isStoreOwner;
  List<PermissionController>? controllers;

  PermissionStore({
    this.storeId,
    this.storeName,
    this.isStoreOwner,
    this.controllers,
  });

  PermissionStore copyWith({
    String? storeId,
    String? storeName,
    bool? isStoreOwner,
    List<PermissionController>? controllers,
  }) =>
      PermissionStore(
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        isStoreOwner: isStoreOwner ?? this.isStoreOwner,
        controllers: controllers ?? this.controllers,
      );

  factory PermissionStore.fromJson(Map<String, dynamic> json) =>
      PermissionStore(
        storeId: json["store_id"],
        storeName: json["store_name"],
        isStoreOwner: json["is_store_owner"],
        controllers: json["controllers"] == null
            ? []
            : List<PermissionController>.from(json["controllers"]!
                .map((x) => PermissionController.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_name": storeName,
        "is_store_owner": isStoreOwner,
        "controllers": controllers == null
            ? []
            : List<dynamic>.from(controllers!.map((x) => x.toJson())),
      };
}

class PermissionController {
  String? controllerId;
  String? controllerKey;
  String? controllerName;

  PermissionController({
    this.controllerId,
    this.controllerKey,
    this.controllerName,
  });

  PermissionController copyWith({
    String? controllerId,
    String? controllerKey,
    String? controllerName,
  }) =>
      PermissionController(
        controllerId: controllerId ?? this.controllerId,
        controllerKey: controllerKey ?? this.controllerKey,
        controllerName: controllerName ?? this.controllerName,
      );

  factory PermissionController.fromJson(Map<String, dynamic> json) =>
      PermissionController(
        controllerId: json["controller_id"],
        controllerKey: json["controller_key"],
        controllerName: json["controller_name"],
      );

  Map<String, dynamic> toJson() => {
        "controller_id": controllerId,
        "controller_key": controllerKey,
        "controller_name": controllerName,
      };
}

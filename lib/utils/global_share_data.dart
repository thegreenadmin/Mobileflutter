import 'dart:convert';

import 'package:get/get.dart';

RxString roleApp = "".obs;
RxString authToken = "".obs;
RxInt pageIdApp = 0.obs;
RxBool hasStoreAccess = false.obs;
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

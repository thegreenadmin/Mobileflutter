// To parse this JSON data, do
//
//     final storeRoleListResponse = storeRoleListResponseFromJson(jsonString);

import 'dart:convert';

StoreRoleListResponse storeRoleListResponseFromJson(String str) => StoreRoleListResponse.fromJson(json.decode(str));

String storeRoleListResponseToJson(StoreRoleListResponse data) => json.encode(data.toJson());

class StoreRoleListResponse {
  StoreRoleListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  StoreRoleListResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      StoreRoleListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreRoleListResponse.fromJson(Map<String, dynamic> json) => StoreRoleListResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.storeRoles,
  });

  List<StoreRole>? storeRoles;

  Data copyWith({
    List<StoreRole>? storeRoles,
  }) =>
      Data(
        storeRoles: storeRoles ?? this.storeRoles,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    storeRoles: json["store_roles"] == null ? [] : List<StoreRole>.from(json["store_roles"]!.map((x) => StoreRole.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "store_roles": storeRoles == null ? [] : List<dynamic>.from(storeRoles!.map((x) => x.toJson())),
  };
}

class StoreRole {
  StoreRole({
    this.roleId,
    this.roleName,
  });

  String? roleId;
  String? roleName;

  StoreRole copyWith({
    String? roleId,
    String? roleName,
  }) =>
      StoreRole(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
      );

  factory StoreRole.fromJson(Map<String, dynamic> json) => StoreRole(
    roleId: json["role_id"],
    roleName: json["role_name"],
  );

  Map<String, dynamic> toJson() => {
    "role_id": roleId,
    "role_name": roleName,
  };
}

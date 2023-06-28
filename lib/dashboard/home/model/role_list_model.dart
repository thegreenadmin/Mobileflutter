// To parse this JSON data, do
//
//     final storeRoleListResponse = storeRoleListResponseFromJson(jsonString);
import 'dart:convert';

import 'model.dart';

StoreRoleListResponse storeRoleListResponseFromJson(String str) =>
    StoreRoleListResponse.fromJson(json.decode(str));

String storeRoleListResponseToJson(StoreRoleListResponse data) =>
    json.encode(data.toJson());

class StoreRoleListResponse {
  StoreRoleListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  StoreRoleListData? data;

  StoreRoleListResponse copyWith({
    int? status,
    String? message,
    StoreRoleListData? data,
  }) =>
      StoreRoleListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreRoleListResponse.fromJson(Map<String, dynamic> json) =>
      StoreRoleListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StoreRoleListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class StoreRoleListData {
  StoreRoleListData({
    this.storeRoles,
  });

  List<StoreRole>? storeRoles;

  StoreRoleListData copyWith({
    List<StoreRole>? storeRoles,
  }) =>
      StoreRoleListData(
        storeRoles: storeRoles ?? this.storeRoles,
      );

  factory StoreRoleListData.fromJson(Map<String, dynamic> json) =>
      StoreRoleListData(
        storeRoles: json["store_roles"] == null
            ? []
            : List<StoreRole>.from(
                json["store_roles"]!.map((x) => StoreRole.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_roles": storeRoles == null
            ? []
            : List<dynamic>.from(storeRoles!.map((x) => x.toJson())),
      };
}

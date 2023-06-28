// To parse this JSON data, do
//
//     final workerListResponse = workerListResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

WorkerListResponse workerListResponseFromJson(String str) =>
    WorkerListResponse.fromJson(json.decode(str));

String workerListResponseToJson(WorkerListResponse data) =>
    json.encode(data.toJson());

class WorkerListResponse {
  WorkerListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  WorkerListData? data;

  WorkerListResponse copyWith({
    int? status,
    String? message,
    WorkerListData? data,
  }) =>
      WorkerListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory WorkerListResponse.fromJson(Map<String, dynamic> json) =>
      WorkerListResponse(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : WorkerListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class WorkerListData {
  WorkerListData({
    this.totalCount,
    this.storeUsers,
  });

  int? totalCount;
  List<StoreUser>? storeUsers;

  WorkerListData copyWith({
    int? totalCount,
    List<StoreUser>? storeUsers,
  }) =>
      WorkerListData(
        totalCount: totalCount ?? this.totalCount,
        storeUsers: storeUsers ?? this.storeUsers,
      );

  factory WorkerListData.fromJson(Map<String, dynamic> json) => WorkerListData(
        totalCount: json["total_count"],
        storeUsers: json["store_users"] == null
            ? []
            : List<StoreUser>.from(
                json["store_users"]!.map((x) => StoreUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "store_users": storeUsers == null
            ? []
            : List<dynamic>.from(storeUsers!.map((x) => x.toJson())),
      };
}

class WorkerListUser {
  WorkerListUser({
    this.userId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.userAddresses,
    this.image,
  });

  String? userId;
  String? email;
  String? phone;
  String? firstName;
  String? lastName;
  List<UserAddress>? userAddresses;
  Images? image;

  WorkerListUser copyWith({
    String? userId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    List<UserAddress>? userAddresses,
    Images? image,
  }) =>
      WorkerListUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        userAddresses: userAddresses ?? this.userAddresses,
        image: image ?? this.image,
      );

  factory WorkerListUser.fromJson(Map<String, dynamic> json) => WorkerListUser(
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userAddresses: json["user_addresses"] == null
            ? []
            : List<UserAddress>.from(
                json["user_addresses"]!.map((x) => UserAddress.fromJson(x))),
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "user_addresses": userAddresses == null
            ? []
            : List<dynamic>.from(userAddresses!.map((x) => x.toJson())),
        "image": image?.toJson(),
      };
}

class UserAddress {
  UserAddress({
    this.userAddressId,
    this.addressName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postalCode,
  });

  String? userAddressId;
  String? addressName;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? postalCode;

  UserAddress copyWith({
    String? userAddressId,
    String? addressName,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
  }) =>
      UserAddress(
        userAddressId: userAddressId ?? this.userAddressId,
        addressName: addressName ?? this.addressName,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
      );

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        userAddressId: json["user_address_id"],
        addressName: json["address_name"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        city: json["city"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "user_address_id": userAddressId,
        "address_name": addressName,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "city": city,
        "postal_code": postalCode,
      };
}

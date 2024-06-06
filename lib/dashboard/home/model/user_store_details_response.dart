// To parse this JSON data, do
//
//     final storeDetailsResponse = storeDetailsResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

StoreDetailsResponse storeDetailsResponseFromJson(String str) =>
    StoreDetailsResponse.fromJson(json.decode(str));

String storeDetailsResponseToJson(StoreDetailsResponse data) =>
    json.encode(data.toJson());

class StoreDetailsResponse {
  dynamic status;
  String? message;
  UserStoreDetails? data;

  StoreDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  StoreDetailsResponse copyWith({
    dynamic status,
    String? message,
    UserStoreDetails? data,
  }) =>
      StoreDetailsResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreDetailsResponse.fromJson(Map<String, dynamic> json) =>
      StoreDetailsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UserStoreDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserStoreDetails {
  Store? store;

  UserStoreDetails({
    this.store,
  });

  UserStoreDetails copyWith({
    Store? store,
  }) =>
      UserStoreDetails(
        store: store ?? this.store,
      );

  factory UserStoreDetails.fromJson(Map<String, dynamic> json) => UserStoreDetails(
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "store": store?.toJson(),
      };
}

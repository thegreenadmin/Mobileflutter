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
  StoreDetails? data;

  StoreDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  StoreDetailsResponse copyWith({
    dynamic status,
    String? message,
    StoreDetails? data,
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
        data: json["data"] == null ? null : StoreDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class StoreDetails {
  Store? store;

  StoreDetails({
    this.store,
  });

  StoreDetails copyWith({
    Store? store,
  }) =>
      StoreDetails(
        store: store ?? this.store,
      );

  factory StoreDetails.fromJson(Map<String, dynamic> json) => StoreDetails(
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "store": store?.toJson(),
      };
}

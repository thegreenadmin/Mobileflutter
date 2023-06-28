// To parse this JSON data, do
//
//     final storeOffersListResponse = storeOffersListResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

StoreOffersListResponse storeOffersListResponseFromJson(String str) =>
    StoreOffersListResponse.fromJson(json.decode(str));

String storeOffersListResponseToJson(StoreOffersListResponse data) =>
    json.encode(data.toJson());

class StoreOffersListResponse {
  StoreOffersListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  StoreOffersListData? data;

  StoreOffersListResponse copyWith({
    int? status,
    String? message,
    StoreOffersListData? data,
  }) =>
      StoreOffersListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreOffersListResponse.fromJson(Map<String, dynamic> json) =>
      StoreOffersListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StoreOffersListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class StoreOffersListData {
  StoreOffersListData({
    this.offers,
  });

  List<Offer>? offers;

  StoreOffersListData copyWith({
    List<Offer>? offers,
  }) =>
      StoreOffersListData(
        offers: offers ?? this.offers,
      );

  factory StoreOffersListData.fromJson(Map<String, dynamic> json) =>
      StoreOffersListData(
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offers": offers == null
            ? []
            : List<dynamic>.from(offers!.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final quantityListResponse = quantityListResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

QuantityListResponse quantityListResponseFromJson(String str) =>
    QuantityListResponse.fromJson(json.decode(str));

String quantityListResponseToJson(QuantityListResponse data) =>
    json.encode(data.toJson());

class QuantityListResponse {
  QuantityListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  QuantityListData? data;

  QuantityListResponse copyWith({
    int? status,
    String? message,
    QuantityListData? data,
  }) =>
      QuantityListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory QuantityListResponse.fromJson(Map<String, dynamic> json) =>
      QuantityListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : QuantityListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class QuantityListData {
  QuantityListData({
    this.quantityTypes,
  });

  List<QuantityType>? quantityTypes;

  QuantityListData copyWith({
    List<QuantityType>? quantityTypes,
  }) =>
      QuantityListData(
        quantityTypes: quantityTypes ?? this.quantityTypes,
      );

  factory QuantityListData.fromJson(Map<String, dynamic> json) =>
      QuantityListData(
        quantityTypes: json["quantity_types"] == null
            ? []
            : List<QuantityType>.from(
                json["quantity_types"]!.map((x) => QuantityType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quantity_types": quantityTypes == null
            ? []
            : List<dynamic>.from(quantityTypes!.map((x) => x.toJson())),
      };
}

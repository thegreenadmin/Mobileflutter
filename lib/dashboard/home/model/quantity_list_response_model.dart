// To parse this JSON data, do
//
//     final quantityListResponse = quantityListResponseFromJson(jsonString);

import 'dart:convert';

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
  Data? data;

  QuantityListResponse copyWith({
    int? status,
    String? message,
    Data? data,
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
    this.quantityTypes,
  });

  List<QuantityType>? quantityTypes;

  Data copyWith({
    List<QuantityType>? quantityTypes,
  }) =>
      Data(
        quantityTypes: quantityTypes ?? this.quantityTypes,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

class QuantityType {
  QuantityType({
    this.quantityTypeId,
    this.quantityTypeName,
  });

  String? quantityTypeId;
  String? quantityTypeName;

  QuantityType copyWith({
    String? quantityTypeId,
    String? quantityTypeName,
  }) =>
      QuantityType(
        quantityTypeId: quantityTypeId ?? this.quantityTypeId,
        quantityTypeName: quantityTypeName ?? this.quantityTypeName,
      );

  factory QuantityType.fromJson(Map<String, dynamic> json) => QuantityType(
        quantityTypeId: json["quantity_type_id"],
        quantityTypeName: json["quantity_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "quantity_type_id": quantityTypeId,
        "quantity_type_name": quantityTypeName,
      };
}

// To parse this JSON data, do
//
//     final storeCategoriesListResponse = storeCategoriesListResponseFromJson(jsonString);
import 'dart:convert';

import 'model.dart';

StoreCategoriesListResponse storeCategoriesListResponseFromJson(String str) =>
    StoreCategoriesListResponse.fromJson(json.decode(str));

String storeCategoriesListResponseToJson(StoreCategoriesListResponse data) =>
    json.encode(data.toJson());

class StoreCategoriesListResponse {
  StoreCategoriesListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  StoreCategoriesListData? data;

  StoreCategoriesListResponse copyWith({
    int? status,
    String? message,
    StoreCategoriesListData? data,
  }) =>
      StoreCategoriesListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreCategoriesListResponse.fromJson(Map<String, dynamic> json) =>
      StoreCategoriesListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StoreCategoriesListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class StoreCategoriesListData {
  StoreCategoriesListData({
    this.categories,
  });

  List<Category>? categories;

  StoreCategoriesListData copyWith({
    List<Category>? categories,
  }) =>
      StoreCategoriesListData(
        categories: categories ?? this.categories,
      );

  factory StoreCategoriesListData.fromJson(Map<String, dynamic> json) =>
      StoreCategoriesListData(
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

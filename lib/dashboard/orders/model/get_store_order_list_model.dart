// To parse this JSON data, do
//
//     final storeOrderListResponse = storeOrderListResponseFromJson(jsonString);

import 'dart:convert';

import 'orders_model.dart';

StoreOrderListResponse storeOrderListResponseFromJson(String str) =>
    StoreOrderListResponse.fromJson(json.decode(str));

String storeOrderListResponseToJson(StoreOrderListResponse data) =>
    json.encode(data.toJson());

class StoreOrderListResponse {
  StoreOrderListResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  StoreOrderListData? data;

  StoreOrderListResponse copyWith({
    dynamic status,
    String? message,
    StoreOrderListData? data,
  }) =>
      StoreOrderListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreOrderListResponse.fromJson(Map<String, dynamic> json) =>
      StoreOrderListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StoreOrderListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class StoreOrderListData {
  StoreOrderListData({
    this.totalCount,
    this.orders,
  });

  dynamic totalCount;
  List<Order>? orders;

  StoreOrderListData copyWith({
    dynamic totalCount,
    List<Order>? orders,
  }) =>
      StoreOrderListData(
        totalCount: totalCount ?? this.totalCount,
        orders: orders ?? this.orders,
      );

  factory StoreOrderListData.fromJson(Map<String, dynamic> json) =>
      StoreOrderListData(
        totalCount: json["total_count"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(
                json["orders"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}


// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);

import 'dart:convert';

OrderListResponse orderListResponseFromJson(String str) => OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) => json.encode(data.toJson());

class OrderListResponse {
  OrderListResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  List<OrderList>? data;

  OrderListResponse copyWith({
    dynamic status,
    String? message,
    List<OrderList>? data,
  }) =>
      OrderListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OrderListResponse.fromJson(Map<String, dynamic> json) => OrderListResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<OrderList>.from(json["data"]!.map((x) => OrderList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OrderList {
  OrderList({
    this.orderStateNumber,
    this.orderStatusName,
    this.onlyUserAccess,
    this.onlyStoreAccess,
    this.status,
    this.orderStatusId,
  });

  dynamic orderStateNumber;
  String? orderStatusName;
  bool? onlyUserAccess;
  bool? onlyStoreAccess;
  String? status;
  String? orderStatusId;

  OrderList copyWith({
    dynamic orderStateNumber,
    String? orderStatusName,
    bool? onlyUserAccess,
    bool? onlyStoreAccess,
    String? status,
    String? orderStatusId,
  }) =>
      OrderList(
        orderStateNumber: orderStateNumber ?? this.orderStateNumber,
        orderStatusName: orderStatusName ?? this.orderStatusName,
        onlyUserAccess: onlyUserAccess ?? this.onlyUserAccess,
        onlyStoreAccess: onlyStoreAccess ?? this.onlyStoreAccess,
        status: status ?? this.status,
        orderStatusId: orderStatusId ?? this.orderStatusId,
      );

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
    orderStateNumber: json["order_state_number"],
    orderStatusName: json["order_status_name"],
    onlyUserAccess: json["only_user_access"],
    onlyStoreAccess: json["only_store_access"],
    status: json["status"],
    orderStatusId: json["order_status_id"],
  );

  Map<String, dynamic> toJson() => {
    "order_state_number": orderStateNumber,
    "order_status_name": orderStatusName,
    "only_user_access": onlyUserAccess,
    "only_store_access": onlyStoreAccess,
    "status": status,
    "order_status_id": orderStatusId,
  };
}

// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);

import 'dart:convert';

OrderStatusListResponse orderListResponseFromJson(String str) => OrderStatusListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderStatusListResponse data) => json.encode(data.toJson());

class OrderStatusListResponse {
  OrderStatusListResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  List<OrderStatusList>? data;

  OrderStatusListResponse copyWith({
    dynamic status,
    String? message,
    List<OrderStatusList>? data,
  }) =>
      OrderStatusListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OrderStatusListResponse.fromJson(Map<String, dynamic> json) => OrderStatusListResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<OrderStatusList>.from(json["data"]!.map((x) => OrderStatusList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OrderStatusList {
  OrderStatusList({
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

  OrderStatusList copyWith({
    dynamic orderStateNumber,
    String? orderStatusName,
    bool? onlyUserAccess,
    bool? onlyStoreAccess,
    String? status,
    String? orderStatusId,
  }) =>
      OrderStatusList(
        orderStateNumber: orderStateNumber ?? this.orderStateNumber,
        orderStatusName: orderStatusName ?? this.orderStatusName,
        onlyUserAccess: onlyUserAccess ?? this.onlyUserAccess,
        onlyStoreAccess: onlyStoreAccess ?? this.onlyStoreAccess,
        status: status ?? this.status,
        orderStatusId: orderStatusId ?? this.orderStatusId,
      );

  factory OrderStatusList.fromJson(Map<String, dynamic> json) => OrderStatusList(
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

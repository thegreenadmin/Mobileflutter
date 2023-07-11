// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);

import 'dart:convert';

import 'orders_model.dart';

OrderListResponse orderListResponseFromJson(String str) =>
    OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) =>
    json.encode(data.toJson());

class OrderListResponse {
  OrderListResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  OrderListResponse copyWith({
    dynamic status,
    String? message,
    Data? data,
  }) =>
      OrderListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      OrderListResponse(
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
    this.totalCount,
    this.orders,
  });

  dynamic totalCount;
  List<Order>? orders;

  Data copyWith({
    dynamic totalCount,
    List<Order>? orders,
  }) =>
      Data(
        totalCount: totalCount ?? this.totalCount,
        orders: orders ?? this.orders,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCount: json["total_count"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.userId,
    this.storeId,
    this.deliveryServiceId,
    this.deliveryCharge,
    this.taxType,
    this.taxValue,
    this.totalTaxCharged,
    this.totalAmount,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerPhoneCode,
    this.estimateDeliveryDate,
    this.orderDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.store,
    this.orderHistories,
    this.orderItems,
    this.orderDeliveryAddresses,
    this.serviceChargeType,
    this.serviceChargeValue,
    this.totalServiceCharged,
    this.deliveryService,
  });

  String? userId;
  String? storeId;
  String? deliveryServiceId;
  dynamic deliveryCharge;
  String? taxType;
  dynamic taxValue;
  dynamic totalTaxCharged;
  dynamic totalAmount;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? customerPhoneCode;
  DateTime? estimateDeliveryDate;
  DateTime? orderDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderId;
  Store? store;
  List<OrderHistories>? orderHistories;
  List<OrderItem>? orderItems;
  List<OrderDeliveryAddress>? orderDeliveryAddresses;
  String? serviceChargeType;
  dynamic serviceChargeValue;
  dynamic totalServiceCharged;
  DeliveryService? deliveryService;

  Order copyWith({
    String? userId,
    String? storeId,
    String? deliveryServiceId,
    dynamic deliveryCharge,
    String? taxType,
    dynamic taxValue,
    dynamic totalTaxCharged,
    dynamic totalAmount,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerPhoneCode,
    DateTime? estimateDeliveryDate,
    DateTime? orderDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderId,
    Store? store,
    List<OrderHistories>? orderHistories,
    List<OrderItem>? orderItems,
    List<OrderDeliveryAddress>? orderDeliveryAddresses,
    String? serviceChargeType,
    dynamic serviceChargeValue,
    dynamic totalServiceCharged,
    DeliveryService? deliveryService,
  }) =>
      Order(
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        taxType: taxType ?? this.taxType,
        taxValue: taxValue ?? this.taxValue,
        totalTaxCharged: totalTaxCharged ?? this.totalTaxCharged,
        totalAmount: totalAmount ?? this.totalAmount,
        customerName: customerName ?? this.customerName,
        customerEmail: customerEmail ?? this.customerEmail,
        customerPhone: customerPhone ?? this.customerPhone,
        customerPhoneCode: customerPhoneCode ?? this.customerPhoneCode,
        estimateDeliveryDate: estimateDeliveryDate ?? this.estimateDeliveryDate,
        orderDate: orderDate ?? this.orderDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderId: orderId ?? this.orderId,
        store: store ?? this.store,
        orderHistories: orderHistories ?? this.orderHistories,
        orderItems: orderItems ?? this.orderItems,
        orderDeliveryAddresses:
            orderDeliveryAddresses ?? this.orderDeliveryAddresses,
        serviceChargeType: serviceChargeType ?? this.serviceChargeType,
        serviceChargeValue: serviceChargeValue ?? this.serviceChargeValue,
        totalServiceCharged: totalServiceCharged ?? this.totalServiceCharged,
        deliveryService: deliveryService ?? this.deliveryService,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json["user_id"],
        storeId: json["store_id"],
        deliveryServiceId: json["delivery_service_id"],
        deliveryCharge: json["delivery_charge"],
        taxType: json["tax_type"],
        taxValue: json["tax_value"]?.toDouble(),
        totalTaxCharged: json["total_tax_charged"]?.toDouble(),
        totalAmount: json["total_amount"]?.toDouble(),
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        customerPhoneCode: json["customer_phone_code"],
        estimateDeliveryDate: json["estimate_delivery_date"] == null
            ? null
            : DateTime.parse(json["estimate_delivery_date"]),
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        orderId: json["order_id"],
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
        orderHistories: json["order_histories"] == null
            ? []
            : List<OrderHistories>.from(json["order_histories"]!
                .map((x) => OrderHistories.fromJson(x))),
        orderItems: json["order_items"] == null
            ? []
            : List<OrderItem>.from(
                json["order_items"]!.map((x) => OrderItem.fromJson(x))),
        orderDeliveryAddresses: json["order_delivery_addresses"] == null
            ? []
            : List<OrderDeliveryAddress>.from(json["order_delivery_addresses"]!
                .map((x) => OrderDeliveryAddress.fromJson(x))),
        serviceChargeType: json["service_charge_type"],
        serviceChargeValue: json["service_charge_value"]?.toDouble(),
        totalServiceCharged: json["total_service_charged"]?.toDouble(),
        deliveryService: json['delivery_service'] != null
            ? DeliveryService.fromJson(json['delivery_service'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "store_id": storeId,
        "delivery_service_id": deliveryServiceId,
        "delivery_charge": deliveryCharge,
        "tax_type": taxType,
        "tax_value": taxValue,
        "total_tax_charged": totalTaxCharged,
        "total_amount": totalAmount,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "customer_phone_code": customerPhoneCode,
        "estimate_delivery_date": estimateDeliveryDate?.toIso8601String(),
        "order_date": orderDate?.toIso8601String(),
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "order_id": orderId,
        "store": store?.toJson(),
        "delivery_service": deliveryService?.toJson(),
        "order_histories": orderHistories == null
            ? []
            : List<dynamic>.from(orderHistories!.map((x) => x.toJson())),
        "order_items": orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
        "order_delivery_addresses": orderDeliveryAddresses == null
            ? []
            : List<dynamic>.from(
                orderDeliveryAddresses!.map((x) => x.toJson())),
        "service_charge_type": serviceChargeType,
        "service_charge_value": serviceChargeValue,
        "total_service_charged": totalServiceCharged,
      };
}

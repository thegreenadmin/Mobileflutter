// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);

import 'dart:convert';

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
  List<OrderHistory>? orderHistories;
  List<OrderItem>? orderItems;
  List<OrderDeliveryAddress>? orderDeliveryAddresses;
  String? serviceChargeType;
  dynamic serviceChargeValue;
  dynamic totalServiceCharged;

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
    List<OrderHistory>? orderHistories,
    List<OrderItem>? orderItems,
    List<OrderDeliveryAddress>? orderDeliveryAddresses,
    String? serviceChargeType,
    dynamic serviceChargeValue,
    dynamic totalServiceCharged,
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
            : List<OrderHistory>.from(
                json["order_histories"]!.map((x) => OrderHistory.fromJson(x))),
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

class OrderDeliveryAddress {
  OrderDeliveryAddress({
    this.orderId,
    this.stateId,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.postalCode,
    this.orderDeliveryAddressId,
  });

  String? orderId;
  String? stateId;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  String? orderDeliveryAddressId;

  OrderDeliveryAddress copyWith({
    String? orderId,
    String? stateId,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? city,
    String? postalCode,
    String? orderDeliveryAddressId,
  }) =>
      OrderDeliveryAddress(
        orderId: orderId ?? this.orderId,
        stateId: stateId ?? this.stateId,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        landmark: landmark ?? this.landmark,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        orderDeliveryAddressId:
            orderDeliveryAddressId ?? this.orderDeliveryAddressId,
      );

  factory OrderDeliveryAddress.fromJson(Map<String, dynamic> json) =>
      OrderDeliveryAddress(
        orderId: json["order_id"],
        stateId: json["state_id"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        landmark: json["landmark"],
        city: json["city"],
        postalCode: json["postal_code"],
        orderDeliveryAddressId: json["order_delivery_address_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "state_id": stateId,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "landmark": landmark,
        "city": city,
        "postal_code": postalCode,
        "order_delivery_address_id": orderDeliveryAddressId,
      };
}

class OrderHistory {
  OrderHistory({
    this.orderHistoryId,
    this.orderStatusId,
    this.createdAt,
    this.updatedAt,
    this.orderStatus,
  });

  String? orderHistoryId;
  String? orderStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  OrderStatus? orderStatus;

  OrderHistory copyWith({
    String? orderHistoryId,
    String? orderStatusId,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderStatus? orderStatus,
  }) =>
      OrderHistory(
        orderHistoryId: orderHistoryId ?? this.orderHistoryId,
        orderStatusId: orderStatusId ?? this.orderStatusId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderStatus: orderStatus ?? this.orderStatus,
      );

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        orderHistoryId: json["order_history_id"],
        orderStatusId: json["order_status_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        orderStatus: json["order_status"] == null
            ? null
            : OrderStatus.fromJson(json["order_status"]),
      );

  Map<String, dynamic> toJson() => {
        "order_history_id": orderHistoryId,
        "order_status_id": orderStatusId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "order_status": orderStatus?.toJson(),
      };
}

class OrderStatus {
  OrderStatus({
    this.orderStatusId,
    this.orderStatusName,
  });

  String? orderStatusId;
  String? orderStatusName;

  OrderStatus copyWith({
    String? orderStatusId,
    String? orderStatusName,
  }) =>
      OrderStatus(
        orderStatusId: orderStatusId ?? this.orderStatusId,
        orderStatusName: orderStatusName ?? this.orderStatusName,
      );

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        orderStatusId: json["order_status_id"],
        orderStatusName: json["order_status_name"],
      );

  Map<String, dynamic> toJson() => {
        "order_status_id": orderStatusId,
        "order_status_name": orderStatusName,
      };
}

class OrderItem {
  OrderItem({
    this.orderId,
    this.productId,
    this.orderItemCount,
    this.orderItemPrice,
    this.serviceChargeType,
    this.serviceChargeValue,
    this.totalServiceCharged,
    this.discountName,
    this.discountType,
    this.discountValue,
    this.totalDiscount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderItemId,
    this.orderItemStatus,
    this.cancelledAt,
    this.shippedAt,
    this.deliveredAt,
    this.returedAt,
  });

  String? orderId;
  String? productId;
  dynamic orderItemCount;
  dynamic orderItemPrice;
  String? serviceChargeType;
  dynamic serviceChargeValue;
  dynamic totalServiceCharged;
  String? discountName;
  String? discountType;
  dynamic discountValue;
  dynamic totalDiscount;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderItemId;
  String? orderItemStatus;
  dynamic cancelledAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic returedAt;

  OrderItem copyWith({
    String? orderId,
    String? productId,
    dynamic orderItemCount,
    dynamic orderItemPrice,
    String? serviceChargeType,
    dynamic serviceChargeValue,
    dynamic totalServiceCharged,
    String? discountName,
    String? discountType,
    dynamic discountValue,
    dynamic totalDiscount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderItemId,
    String? orderItemStatus,
    dynamic cancelledAt,
    dynamic shippedAt,
    dynamic deliveredAt,
    dynamic returedAt,

  }) =>
      OrderItem(
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        orderItemCount: orderItemCount ?? this.orderItemCount,
        orderItemPrice: orderItemPrice ?? this.orderItemPrice,
        serviceChargeType: serviceChargeType ?? this.serviceChargeType,
        serviceChargeValue: serviceChargeValue ?? this.serviceChargeValue,
        totalServiceCharged: totalServiceCharged ?? this.totalServiceCharged,
        discountName: discountName ?? this.discountName,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderItemId: orderItemId ?? this.orderItemId,
        orderItemStatus: orderItemStatus ?? this.orderItemStatus,
        cancelledAt: cancelledAt ?? this.cancelledAt,
        shippedAt: shippedAt ?? this.shippedAt,
        deliveredAt: deliveredAt ?? this.deliveredAt,
        returedAt: returedAt ?? this.returedAt,
      );

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderId: json["order_id"],
        productId: json["product_id"],
        orderItemCount: json["order_item_count"],
        orderItemPrice: json["order_item_price"],
        serviceChargeType: json["service_charge_type"],
        serviceChargeValue: json["service_charge_value"]?.toDouble(),
        totalServiceCharged: json["total_service_charged"]?.toDouble(),
        discountName: json["discount_name"],
        discountType: json["discount_type"],
        discountValue: json["discount_value"],
        totalDiscount: json["total_discount"]?.toDouble(),
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        orderItemId: json["order_item_id"],
        orderItemStatus: json["order_item_status"],
        cancelledAt: json["cancelledAt"],
        shippedAt: json["shippedAt"],
        deliveredAt: json["deliveredAt"],
        returedAt: json["returedAt"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "order_item_count": orderItemCount,
        "order_item_price": orderItemPrice,
        "service_charge_type": serviceChargeType,
        "service_charge_value": serviceChargeValue,
        "total_service_charged": totalServiceCharged,
        "discount_name": discountName,
        "discount_type": discountType,
        "discount_value": discountValue,
        "total_discount": totalDiscount,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "order_item_id": orderItemId,
        "order_item_status": orderItemStatus,
        "cancelledAt": cancelledAt,
        "shippedAt": shippedAt,
        "deliveredAt": deliveredAt,
        "returedAt": returedAt,
  };
}

class Store {
  Store({
    this.storeId,
    this.storeName,
    this.isVerified,
    this.isEnabled,
    this.image,
    this.logo,
  });

  String? storeId;
  String? storeName;
  bool? isVerified;
  bool? isEnabled;
  Image? image;
  Image? logo;

  Store copyWith({
    String? storeId,
    String? storeName,
    bool? isVerified,
    bool? isEnabled,
    Image? image,
    Image? logo,
  }) =>
      Store(
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        isVerified: isVerified ?? this.isVerified,
        isEnabled: isEnabled ?? this.isEnabled,
        image: image ?? this.image,
        logo: logo ?? this.logo,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeId: json["store_id"],
        storeName: json["store_name"],
        isVerified: json["is_verified"],
        isEnabled: json["is_enabled"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        logo: json["logo"] == null ? null : Image.fromJson(json["logo"]),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_name": storeName,
        "is_verified": isVerified,
        "is_enabled": isEnabled,
        "image": image?.toJson(),
        "logo": logo?.toJson(),
      };
}

class Image {
  Image({
    this.orignalUrl,
    this.dynamicUrl,
  });

  String? orignalUrl;
  String? dynamicUrl;

  Image copyWith({
    String? orignalUrl,
    String? dynamicUrl,
  }) =>
      Image(
        orignalUrl: orignalUrl ?? this.orignalUrl,
        dynamicUrl: dynamicUrl ?? this.dynamicUrl,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        orignalUrl: json["orignal_url"],
        dynamicUrl: json["dynamic_url"],
      );

  Map<String, dynamic> toJson() => {
        "orignal_url": orignalUrl,
        "dynamic_url": dynamicUrl,
      };
}

// To parse this JSON data, do
//
//     final orderDetailResponse = orderDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'orders_model.dart';

OrderDetailResponse orderDetailResponseFromJson(String str) =>
    OrderDetailResponse.fromJson(json.decode(str));

String orderDetailResponseToJson(OrderDetailResponse data) =>
    json.encode(data.toJson());

class OrderDetailResponse {
  OrderDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  OrderDetailData? data;

  OrderDetailResponse copyWith({
    dynamic status,
    String? message,
    OrderDetailData? data,
  }) =>
      OrderDetailResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : OrderDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class OrderDetailData {
  OrderDetailData({
    this.order,
    this.sentNotification,
  });

  Order? order;
  SentNotification? sentNotification;

  OrderDetailData copyWith({
    Order? order,
    SentNotification? sentNotification,
  }) =>
      OrderDetailData(
        order: order ?? this.order,
        sentNotification: sentNotification ?? this.sentNotification,
      );

  factory OrderDetailData.fromJson(Map<String, dynamic> json) =>
      OrderDetailData(
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
        sentNotification: json["sentNotification"] == null ? null : SentNotification.fromJson(json["sentNotification"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order?.toJson(),
        "sentNotification": sentNotification?.toJson(),
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
    this.state,
  });

  String? orderId;
  String? stateId;
  String? addressLine1;
  String? addressLine2;
  dynamic landmark;
  String? city;
  String? postalCode;
  String? orderDeliveryAddressId;
  State? state;

  OrderDeliveryAddress copyWith({
    String? orderId,
    String? stateId,
    String? addressLine1,
    String? addressLine2,
    dynamic landmark,
    String? city,
    String? postalCode,
    String? orderDeliveryAddressId,
    State? state,
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
        state: state ?? this.state,
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
        state: json["state"] == null ? null : State.fromJson(json["state"]),
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
        "state": state?.toJson(),
      };
}

class OrderItem {
  OrderItem({
    this.serviceChargeType,
    this.serviceChargeValue,
    this.totalServiceCharged,
    this.orderId,
    this.productId,
    this.orderItemCount,
    this.orderItemPrice,
    this.discountName,
    this.discountType,
    this.discountValue,
    this.totalDiscount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderItemId,
    this.product,
    this.returnOrderItems,
    this.orderItemStatus,
    this.cancelledAt,
    this.shippedAt,
    this.deliveredAt,
    this.returedAt,
    this.enableReturnButton,
    this.offerPrice,
    this.isSelected,
  });

  String? orderId;
  String? productId;
  dynamic orderItemCount;
  dynamic orderItemPrice;
  String? discountName;
  String? discountType;
  dynamic discountValue;
  dynamic totalDiscount;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderItemId;
  Product? product;
  List<ReturnOrderItem>? returnOrderItems;
  String? orderItemStatus;
  dynamic cancelledAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic returedAt;
  bool? enableReturnButton;
  dynamic offerPrice;
  String? serviceChargeType;
  dynamic serviceChargeValue;
  dynamic totalServiceCharged;
  bool? isSelected;

  OrderItem copyWith({
    String? orderId,
    String? productId,
    dynamic orderItemCount,
    dynamic orderItemPrice,
    String? discountName,
    String? discountType,
    dynamic discountValue,
    dynamic totalDiscount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderItemId,
    Product? product,
    List<ReturnOrderItem>? returnOrderItems,
    String? orderItemStatus,
    dynamic cancelledAt,
    dynamic shippedAt,
    dynamic deliveredAt,
    dynamic returedAt,
    bool? enableReturnButton,
    dynamic offerPrice,
    String? serviceChargeType,
    dynamic serviceChargeValue,
    dynamic totalServiceCharged,
    bool? isSelected,
  }) =>
      OrderItem(
        orderId: orderId ?? this.orderId,
        isSelected: isSelected ?? this.isSelected,
        productId: productId ?? this.productId,
        orderItemCount: orderItemCount ?? this.orderItemCount,
        orderItemPrice: orderItemPrice ?? this.orderItemPrice,
        discountName: discountName ?? this.discountName,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderItemId: orderItemId ?? this.orderItemId,
        product: product ?? this.product,
        returnOrderItems: returnOrderItems ?? this.returnOrderItems,
        orderItemStatus: orderItemStatus ?? this.orderItemStatus,
        cancelledAt: cancelledAt ?? this.cancelledAt,
        shippedAt: shippedAt ?? this.shippedAt,
        deliveredAt: deliveredAt ?? this.deliveredAt,
        returedAt: returedAt ?? this.returedAt,
        enableReturnButton: enableReturnButton ?? this.enableReturnButton,
        offerPrice: offerPrice ?? this.offerPrice,
        serviceChargeType: serviceChargeType ?? this.serviceChargeType,
        serviceChargeValue: serviceChargeValue ?? this.serviceChargeValue,
        totalServiceCharged: totalServiceCharged ?? this.totalServiceCharged,
      );

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderId: json["order_id"],
        serviceChargeType: json['service_charge_type'],
        serviceChargeValue: json['service_charge_value'],
        totalServiceCharged: json['total_service_charged'],
        productId: json["product_id"],
        orderItemCount: json["order_item_count"],
        orderItemPrice: json["order_item_price"],
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
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        returnOrderItems: json["return_order_items"] == null
            ? []
            : List<ReturnOrderItem>.from(json["return_order_items"]!
                .map((x) => ReturnOrderItem.fromJson(x))),
        orderItemStatus: json["order_item_status"],
        cancelledAt: json["cancelledAt"],
        shippedAt: json["shippedAt"],
        deliveredAt: json["deliveredAt"],
        returedAt: json["returedAt"],
        enableReturnButton: json["enable_return_button"],
        offerPrice: json["offer_price"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "order_item_count": orderItemCount,
        "order_item_price": orderItemPrice,
        "discount_name": discountName,
        "discount_type": discountType,
        "discount_value": discountValue,
        "total_discount": totalDiscount,
        "service_charge_type": serviceChargeType,
        "service_charge_value": serviceChargeValue,
        "total_service_charged": totalServiceCharged,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "order_item_id": orderItemId,
        "product": product?.toJson(),
        "return_order_items": returnOrderItems == null
            ? []
            : List<dynamic>.from(returnOrderItems!.map((x) => x.toJson())),
        "order_item_status": orderItemStatus,
        "cancelledAt": cancelledAt,
        "shippedAt": shippedAt,
        "deliveredAt": deliveredAt,
        "returedAt": returedAt,
        "enable_return_button": enableReturnButton,
        "offer_price": offerPrice,
      };
}

class ProductImage {
  ProductImage({
    this.productId,
    this.imageUrl,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.productImageId,
    this.image,
  });

  String? productId;
  String? imageUrl;
  dynamic order;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? productImageId;
  Images? image;

  ProductImage copyWith({
    String? productId,
    String? imageUrl,
    dynamic order,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? productImageId,
    Images? image,
  }) =>
      ProductImage(
        productId: productId ?? this.productId,
        imageUrl: imageUrl ?? this.imageUrl,
        order: order ?? this.order,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        productImageId: productImageId ?? this.productImageId,
        image: image ?? this.image,
      );

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        productId: json["product_id"],
        imageUrl: json["image_url"],
        order: json["order"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        productImageId: json["product_image_id"],
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "image_url": imageUrl,
        "order": order,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "product_image_id": productImageId,
        "image": image?.toJson(),
      };
}
class SentNotification {
  String? id;
  String? userId;
  String? storeId;
  dynamic messageHeadId;
  String? orderId;
  dynamic offerId;
  bool? isNotificationForStore;
  bool? isSent;
  bool? isRead;
  String? title;
  String? message;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  SentNotification({
    this.id,
    this.userId,
    this.storeId,
    this.messageHeadId,
    this.orderId,
    this.offerId,
    this.isNotificationForStore,
    this.isSent,
    this.isRead,
    this.title,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  SentNotification copyWith({
    String? id,
    String? userId,
    String? storeId,
    dynamic messageHeadId,
    String? orderId,
    dynamic offerId,
    bool? isNotificationForStore,
    bool? isSent,
    bool? isRead,
    String? title,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      SentNotification(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
        messageHeadId: messageHeadId ?? this.messageHeadId,
        orderId: orderId ?? this.orderId,
        offerId: offerId ?? this.offerId,
        isNotificationForStore: isNotificationForStore ?? this.isNotificationForStore,
        isSent: isSent ?? this.isSent,
        isRead: isRead ?? this.isRead,
        title: title ?? this.title,
        message: message ?? this.message,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SentNotification.fromJson(Map<String, dynamic> json) {
    return SentNotification(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      storeId: json['storeId'] as String?,
      messageHeadId: json['messageHeadId'],
      orderId: json['orderId'] as String?,
      offerId: json['offerId'],
      isNotificationForStore: json['isNotificationForStore'] as bool?,
      isSent: json['isSent'] as bool?,
      isRead: json['isRead'] as bool?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
      'messageHeadId': messageHeadId,
      'orderId': orderId,
      'offerId': offerId,
      'isNotificationForStore': isNotificationForStore,
      'isSent': isSent,
      'isRead': isRead,
      'title': title,
      'message': message,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

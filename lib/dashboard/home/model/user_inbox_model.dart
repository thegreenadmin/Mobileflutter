// To parse this JSON data, do
//
//     final userInboxModel = userInboxModelFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

UserInboxModel userInboxModelFromJson(String str) =>
    UserInboxModel.fromJson(json.decode(str));

String userInboxModelToJson(UserInboxModel data) => json.encode(data.toJson());

class UserInboxModel {
  dynamic status;
  String? message;
  UserInboxData? data;

  UserInboxModel({
    this.status,
    this.message,
    this.data,
  });

  UserInboxModel copyWith({
    dynamic status,
    String? message,
    UserInboxData? data,
  }) =>
      UserInboxModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UserInboxModel.fromJson(Map<String, dynamic> json) => UserInboxModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : UserInboxData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserInboxData {
  dynamic totalCount;
  List<MessageHead>? messageHeads;

  UserInboxData({
    this.totalCount,
    this.messageHeads,
  });

  UserInboxData copyWith({
    dynamic totalCount,
    List<MessageHead>? messageHeads,
  }) =>
      UserInboxData(
        totalCount: totalCount ?? this.totalCount,
        messageHeads: messageHeads ?? this.messageHeads,
      );

  factory UserInboxData.fromJson(Map<String, dynamic> json) => UserInboxData(
        totalCount: json["total_count"],
        messageHeads: json["message_heads"] == null
            ? []
            : List<MessageHead>.from(
                json["message_heads"]!.map((x) => MessageHead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "message_heads": messageHeads == null
            ? []
            : List<dynamic>.from(messageHeads!.map((x) => x.toJson())),
      };
}

class MessageHead {
  String? storeId;
  dynamic offerId;
  String? orderId;
  String? userId;
  bool? isAvailableForStore;
  bool? isAvailableForUser;
  bool? isStoreCompleted;
  bool? isUserCompleted;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? messageHeadId;
  InboxStore? store;
  InboxOffer? offer;
  Order? order;
  InboxUser? user;

  MessageHead({
    this.storeId,
    this.offerId,
    this.orderId,
    this.userId,
    this.isAvailableForStore,
    this.isAvailableForUser,
    this.isStoreCompleted,
    this.isUserCompleted,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.messageHeadId,
    this.store,
    this.offer,
    this.order,
    this.user,
  });

  MessageHead copyWith({
    String? storeId,
    dynamic offerId,
    String? orderId,
    String? userId,
    bool? isAvailableForStore,
    bool? isAvailableForUser,
    bool? isStoreCompleted,
    bool? isUserCompleted,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? messageHeadId,
    InboxStore? store,
    InboxOffer? offer,
    Order? order,
    InboxUser? user,
  }) =>
      MessageHead(
        storeId: storeId ?? this.storeId,
        offerId: offerId ?? this.offerId,
        orderId: orderId ?? this.orderId,
        userId: userId ?? this.userId,
        isAvailableForStore: isAvailableForStore ?? this.isAvailableForStore,
        isAvailableForUser: isAvailableForUser ?? this.isAvailableForUser,
        isStoreCompleted: isStoreCompleted ?? this.isStoreCompleted,
        isUserCompleted: isUserCompleted ?? this.isUserCompleted,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        messageHeadId: messageHeadId ?? this.messageHeadId,
        store: store ?? this.store,
        offer: offer ?? this.offer,
        order: order ?? this.order,
        user: user ?? this.user,
      );

  factory MessageHead.fromJson(Map<String, dynamic> json) => MessageHead(
        storeId: json["store_id"],
        offerId: json["offer_id"],
        orderId: json["order_id"],
        userId: json["user_id"],
        isAvailableForStore: json["is_available_for_store"],
        isAvailableForUser: json["is_available_for_user"],
        isStoreCompleted: json["is_store_completed"],
        isUserCompleted: json["is_user_completed"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        messageHeadId: json["message_head_id"],
        store:
            json["store"] == null ? null : InboxStore.fromJson(json["store"]),
        offer:
            json["offer"] == null ? null : InboxOffer.fromJson(json["offer"]),
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
        user: json["user"] == null ? null : InboxUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "offer_id": offerId,
        "order_id": orderId,
        "user_id": userId,
        "is_available_for_store": isAvailableForStore,
        "is_available_for_user": isAvailableForUser,
        "is_store_completed": isStoreCompleted,
        "is_user_completed": isUserCompleted,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "message_head_id": messageHeadId,
        "store": store?.toJson(),
        "offer": offer?.toJson(),
        "order": order?.toJson(),
        "user": user?.toJson(),
      };
}

class InboxOffer {
  String? storeId;
  bool? autoCreated;
  bool? isOfferForStore;
  String? offerName;
  String? imageUrl;
  String? offerType;
  dynamic offerValue;
  bool? isExpired;
  dynamic expiredAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? offerId;

  InboxOffer({
    this.storeId,
    this.autoCreated,
    this.isOfferForStore,
    this.offerName,
    this.imageUrl,
    this.offerType,
    this.offerValue,
    this.isExpired,
    this.expiredAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.offerId,
  });

  InboxOffer copyWith({
    String? storeId,
    bool? autoCreated,
    bool? isOfferForStore,
    String? offerName,
    String? imageUrl,
    String? offerType,
    dynamic offerValue,
    bool? isExpired,
    dynamic expiredAt,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? offerId,
  }) =>
      InboxOffer(
        storeId: storeId ?? this.storeId,
        autoCreated: autoCreated ?? this.autoCreated,
        isOfferForStore: isOfferForStore ?? this.isOfferForStore,
        offerName: offerName ?? this.offerName,
        imageUrl: imageUrl ?? this.imageUrl,
        offerType: offerType ?? this.offerType,
        offerValue: offerValue ?? this.offerValue,
        isExpired: isExpired ?? this.isExpired,
        expiredAt: expiredAt ?? this.expiredAt,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        offerId: offerId ?? this.offerId,
      );

  factory InboxOffer.fromJson(Map<String, dynamic> json) => InboxOffer(
        storeId: json["store_id"],
        autoCreated: json["auto_created"],
        isOfferForStore: json["is_offer_for_store"],
        offerName: json["offer_name"],
        imageUrl: json["image_url"],
        offerType: json["offer_type"],
        offerValue: json["offer_value"],
        isExpired: json["is_expired"],
        expiredAt: json["expiredAt"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        offerId: json["offer_id"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "auto_created": autoCreated,
        "is_offer_for_store": isOfferForStore,
        "offer_name": offerName,
        "image_url": imageUrl,
        "offer_type": offerType,
        "offer_value": offerValue,
        "is_expired": isExpired,
        "expiredAt": expiredAt,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "offer_id": offerId,
      };
}

/*class Order {
  String? userId;
  String? storeId;
  String? deliveryServiceId;
  dynamic deliveryCharge;
  String? taxType;
  double? taxValue;
  double? totalTaxCharged;
  String? serviceChargeType;
  double? serviceChargeValue;
  double? totalServiceCharged;
  double? totalAmount;
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

  Order({
    this.userId,
    this.storeId,
    this.deliveryServiceId,
    this.deliveryCharge,
    this.taxType,
    this.taxValue,
    this.totalTaxCharged,
    this.serviceChargeType,
    this.serviceChargeValue,
    this.totalServiceCharged,
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
  });

  Order copyWith({
    String? userId,
    String? storeId,
    String? deliveryServiceId,
    dynamic deliveryCharge,
    String? taxType,
    double? taxValue,
    double? totalTaxCharged,
    String? serviceChargeType,
    double? serviceChargeValue,
    double? totalServiceCharged,
    double? totalAmount,
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
  }) =>
      Order(
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        taxType: taxType ?? this.taxType,
        taxValue: taxValue ?? this.taxValue,
        totalTaxCharged: totalTaxCharged ?? this.totalTaxCharged,
        serviceChargeType: serviceChargeType ?? this.serviceChargeType,
        serviceChargeValue: serviceChargeValue ?? this.serviceChargeValue,
        totalServiceCharged: totalServiceCharged ?? this.totalServiceCharged,
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
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json["user_id"],
        storeId: json["store_id"],
        deliveryServiceId: json["delivery_service_id"],
        deliveryCharge: json["delivery_charge"],
        taxType: json["tax_type"],
        taxValue: json["tax_value"]?.toDouble(),
        totalTaxCharged: json["total_tax_charged"]?.toDouble(),
        serviceChargeType: json["service_charge_type"],
        serviceChargeValue: json["service_charge_value"]?.toDouble(),
        totalServiceCharged: json["total_service_charged"]?.toDouble(),
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
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "store_id": storeId,
        "delivery_service_id": deliveryServiceId,
        "delivery_charge": deliveryCharge,
        "tax_type": taxType,
        "tax_value": taxValue,
        "total_tax_charged": totalTaxCharged,
        "service_charge_type": serviceChargeType,
        "service_charge_value": serviceChargeValue,
        "total_service_charged": totalServiceCharged,
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
      };
}*/

class InboxStore {
  dynamic storeBalance;
  dynamic dynamicLink;
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storeEmail;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  String? verifiedBy;
  bool? isEnabled;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? storeId;
  Logo? logo;

  InboxStore({
    this.storeBalance,
    this.dynamicLink,
    this.storeName,
    this.storeEin,
    this.storeNickName,
    this.storeEmail,
    this.storePhone,
    this.storePhoneCode,
    this.isVerified,
    this.verifiedBy,
    this.isEnabled,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.storeId,
    this.logo,
  });

  InboxStore copyWith({
    dynamic storeBalance,
    dynamic dynamicLink,
    String? storeName,
    String? storeEin,
    String? storeNickName,
    String? storeEmail,
    String? storePhone,
    String? storePhoneCode,
    bool? isVerified,
    String? verifiedBy,
    bool? isEnabled,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? storeId,
    Logo? logo,
  }) =>
      InboxStore(
        storeBalance: storeBalance ?? this.storeBalance,
        dynamicLink: dynamicLink ?? this.dynamicLink,
        storeName: storeName ?? this.storeName,
        storeEin: storeEin ?? this.storeEin,
        storeNickName: storeNickName ?? this.storeNickName,
        storeEmail: storeEmail ?? this.storeEmail,
        storePhone: storePhone ?? this.storePhone,
        storePhoneCode: storePhoneCode ?? this.storePhoneCode,
        isVerified: isVerified ?? this.isVerified,
        verifiedBy: verifiedBy ?? this.verifiedBy,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        storeId: storeId ?? this.storeId,
        logo: logo ?? this.logo,
      );

  factory InboxStore.fromJson(Map<String, dynamic> json) => InboxStore(
        storeBalance: json["store_balance"],
        dynamicLink: json["dynamic_link"],
        storeName: json["store_name"],
        storeEin: json["store_ein"],
        storeNickName: json["store_nick_name"],
        storeEmail: json["store_email"],
        storePhone: json["store_phone"],
        storePhoneCode: json["store_phone_code"],
        isVerified: json["is_verified"],
        verifiedBy: json["verified_by"],
        isEnabled: json["is_enabled"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        storeId: json["store_id"],
        logo: json["logo"] == null ? null : Logo.fromJson(json["logo"]),
      );

  Map<String, dynamic> toJson() => {
        "store_balance": storeBalance,
        "dynamic_link": dynamicLink,
        "store_name": storeName,
        "store_ein": storeEin,
        "store_nick_name": storeNickName,
        "store_email": storeEmail,
        "store_phone": storePhone,
        "store_phone_code": storePhoneCode,
        "is_verified": isVerified,
        "verified_by": verifiedBy,
        "is_enabled": isEnabled,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "store_id": storeId,
        "logo": logo?.toJson(),
      };
}

class InboxUser {
  dynamic userBalance;
  String? email;
  String? phone;
  String? phoneCode;
  String? firstName;
  String? lastName;
  String? nickName;
  DateTime? dob;
  bool? hasStoreAccess;
  bool? isAccountDeleted;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userId;
  Logo? image;

  InboxUser({
    this.userBalance,
    this.email,
    this.phone,
    this.phoneCode,
    this.firstName,
    this.lastName,
    this.nickName,
    this.dob,
    this.hasStoreAccess,
    this.isAccountDeleted,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.image,
  });

  InboxUser copyWith({
    dynamic userBalance,
    String? email,
    String? phone,
    String? phoneCode,
    String? firstName,
    String? lastName,
    String? nickName,
    DateTime? dob,
    bool? hasStoreAccess,
    bool? isAccountDeleted,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    Logo? image,
  }) =>
      InboxUser(
        userBalance: userBalance ?? this.userBalance,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        phoneCode: phoneCode ?? this.phoneCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        nickName: nickName ?? this.nickName,
        dob: dob ?? this.dob,
        hasStoreAccess: hasStoreAccess ?? this.hasStoreAccess,
        isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
        image: image ?? this.image,
      );

  factory InboxUser.fromJson(Map<String, dynamic> json) => InboxUser(
        userBalance: json["user_balance"],
        email: json["email"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickName: json["nick_name"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        hasStoreAccess: json["has_store_access"],
        isAccountDeleted: json["is_account_deleted"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userId: json["user_id"],
        image: json["image"] == null ? null : Logo.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "user_balance": userBalance,
        "email": email,
        "phone": phone,
        "phone_code": phoneCode,
        "first_name": firstName,
        "last_name": lastName,
        "nick_name": nickName,
        "dob": dob?.toIso8601String(),
        "has_store_access": hasStoreAccess,
        "is_account_deleted": isAccountDeleted,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user_id": userId,
        "image": image?.toJson(),
      };
}

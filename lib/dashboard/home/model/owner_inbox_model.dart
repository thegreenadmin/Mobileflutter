// To parse this JSON data, do
//
//     final ownerInboxModel = ownerInboxModelFromJson(jsonString);

import 'dart:convert';

OwnerInboxModel ownerInboxModelFromJson(String str) =>
    OwnerInboxModel.fromJson(json.decode(str));

String ownerInboxModelToJson(OwnerInboxModel data) =>
    json.encode(data.toJson());

class OwnerInboxModel {
  dynamic status;
  String? message;
  Data? data;

  OwnerInboxModel({
    this.status,
    this.message,
    this.data,
  });

  OwnerInboxModel copyWith({
    dynamic status,
    String? message,
    Data? data,
  }) =>
      OwnerInboxModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OwnerInboxModel.fromJson(Map<String, dynamic> json) =>
      OwnerInboxModel(
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
  dynamic totalCount;
  List<MessageHead>? messageHeads;

  Data({
    this.totalCount,
    this.messageHeads,
  });

  Data copyWith({
    dynamic totalCount,
    List<MessageHead>? messageHeads,
  }) =>
      Data(
        totalCount: totalCount ?? this.totalCount,
        messageHeads: messageHeads ?? this.messageHeads,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  dynamic orderId;
  String? userId;
  bool? isAvailableForStore;
  bool? isAvailableForUser;
  bool? isStoreCompleted;
  bool? isUserCompleted;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? messageHeadId;
  Store? store;
  dynamic offer;
  dynamic order;
  User? user;

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
    dynamic orderId,
    String? userId,
    bool? isAvailableForStore,
    bool? isAvailableForUser,
    bool? isStoreCompleted,
    bool? isUserCompleted,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? messageHeadId,
    Store? store,
    dynamic offer,
    dynamic order,
    User? user,
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
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
        offer: json["offer"],
        order: json["order"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
        "offer": offer,
        "order": order,
        "user": user?.toJson(),
      };
}

class Store {
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

  Store({
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

  Store copyWith({
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
      Store(
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

  factory Store.fromJson(Map<String, dynamic> json) => Store(
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

class Logo {
  String? orignalUrl;
  String? dynamicUrl;

  Logo({
    this.orignalUrl,
    this.dynamicUrl,
  });

  Logo copyWith({
    String? orignalUrl,
    String? dynamicUrl,
  }) =>
      Logo(
        orignalUrl: orignalUrl ?? this.orignalUrl,
        dynamicUrl: dynamicUrl ?? this.dynamicUrl,
      );

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        orignalUrl: json["orignal_url"],
        dynamicUrl: json["dynamic_url"],
      );

  Map<String, dynamic> toJson() => {
        "orignal_url": orignalUrl,
        "dynamic_url": dynamicUrl,
      };
}

class User {
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

  User({
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

  User copyWith({
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
      User(
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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

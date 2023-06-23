// To parse this JSON data, do
//
//     final getOwnerStoresResponse = getOwnerStoresResponseFromJson(jsonString);

import 'dart:convert';

GetOwnerStoresResponse getOwnerStoresResponseFromJson(String str) => GetOwnerStoresResponse.fromJson(json.decode(str));

String getOwnerStoresResponseToJson(GetOwnerStoresResponse data) => json.encode(data.toJson());

class GetOwnerStoresResponse {
  int? status;
  String? message;
  List<Datum>? data;

  GetOwnerStoresResponse({
    this.status,
    this.message,
    this.data,
  });

  GetOwnerStoresResponse copyWith({
    int? status,
    String? message,
    List<Datum>? data,
  }) =>
      GetOwnerStoresResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetOwnerStoresResponse.fromJson(Map<String, dynamic> json) => GetOwnerStoresResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  dynamic storeBalance;
  dynamic dynamicLink;
  String? storeName;
  String? storeEin;
  String? imageUrl;
  String? logoUrl;
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

  Datum({
    this.storeBalance,
    this.dynamicLink,
    this.storeName,
    this.storeEin,
    this.imageUrl,
    this.logoUrl,
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
  });

  Datum copyWith({
    dynamic storeBalance,
    dynamic dynamicLink,
    String? storeName,
    String? storeEin,
    String? imageUrl,
    String? logoUrl,
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
  }) =>
      Datum(
        storeBalance: storeBalance ?? this.storeBalance,
        dynamicLink: dynamicLink ?? this.dynamicLink,
        storeName: storeName ?? this.storeName,
        storeEin: storeEin ?? this.storeEin,
        imageUrl: imageUrl ?? this.imageUrl,
        logoUrl: logoUrl ?? this.logoUrl,
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
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    storeBalance: json["store_balance"],
    dynamicLink: json["dynamic_link"],
    storeName: json["store_name"],
    storeEin: json["store_ein"],
    imageUrl: json["image_url"],
    logoUrl: json["logo_url"],
    storeNickName: json["store_nick_name"],
    storeEmail: json["store_email"],
    storePhone: json["store_phone"],
    storePhoneCode: json["store_phone_code"],
    isVerified: json["is_verified"],
    verifiedBy: json["verified_by"],
    isEnabled: json["is_enabled"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    storeId: json["store_id"],
  );

  Map<String, dynamic> toJson() => {
    "store_balance": storeBalance,
    "dynamic_link": dynamicLink,
    "store_name": storeName,
    "store_ein": storeEin,
    "image_url": imageUrl,
    "logo_url": logoUrl,
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
  };
}

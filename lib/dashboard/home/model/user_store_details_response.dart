// To parse this JSON data, do
//
//     final storeDetailsResponse = storeDetailsResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

StoreDetailsResponse storeDetailsResponseFromJson(String str) =>
    StoreDetailsResponse.fromJson(json.decode(str));

String storeDetailsResponseToJson(StoreDetailsResponse data) =>
    json.encode(data.toJson());

class StoreDetailsResponse {
  dynamic status;
  String? message;
  StoreDetails? data;

  StoreDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  StoreDetailsResponse copyWith({
    dynamic status,
    String? message,
    StoreDetails? data,
  }) =>
      StoreDetailsResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreDetailsResponse.fromJson(Map<String, dynamic> json) =>
      StoreDetailsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : StoreDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class StoreDetails {
  Store? store;

  StoreDetails({
    this.store,
  });

  StoreDetails copyWith({
    Store? store,
  }) =>
      StoreDetails(
        store: store ?? this.store,
      );

  factory StoreDetails.fromJson(Map<String, dynamic> json) => StoreDetails(
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "store": store?.toJson(),
      };
}

class Store {
  Images? image;
  Images? logo;
  bool? isFavouriteStore;
  String? storeId;
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storePhoneCode;
  String? storeEmail;
  String? storePhone;
  bool? isVerified;
  bool? isEnabled;
  String? dynamicLink;
  bool? isfavourite;
  List<StoreAddress>? storeAddresses;
  List<StoreTiming>? storeTimings;
  List<StoreDeliveryService>? storeDeliveryServices;
  List<StorePage>? storePages;

  Store({
    this.image,
    this.logo,
    this.isFavouriteStore,
    this.storeId,
    this.storeName,
    this.storeEin,
    this.storeNickName,
    this.storePhoneCode,
    this.storeEmail,
    this.storePhone,
    this.isVerified,
    this.isEnabled,
    this.dynamicLink,
    this.isfavourite,
    this.storeAddresses,
    this.storeTimings,
    this.storeDeliveryServices,
    this.storePages,
  });

  Store copyWith({
    Images? image,
    Images? logo,
    bool? isFavouriteStore,
    String? storeId,
    String? storeName,
    String? storeEin,
    String? storeNickName,
    String? storePhoneCode,
    String? storeEmail,
    String? storePhone,
    bool? isVerified,
    bool? isEnabled,
    String? dynamicLink,
    bool? isfavourite,
    List<StoreAddress>? storeAddresses,
    List<StoreTiming>? storeTimings,
    List<StoreDeliveryService>? storeDeliveryServices,
    List<StorePage>? storePages,
  }) =>
      Store(
        image: image ?? this.image,
        logo: logo ?? this.logo,
        isFavouriteStore: isFavouriteStore ?? this.isFavouriteStore,
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        storeEin: storeEin ?? this.storeEin,
        storeNickName: storeNickName ?? this.storeNickName,
        storePhoneCode: storePhoneCode ?? this.storePhoneCode,
        storeEmail: storeEmail ?? this.storeEmail,
        storePhone: storePhone ?? this.storePhone,
        isVerified: isVerified ?? this.isVerified,
        isEnabled: isEnabled ?? this.isEnabled,
        dynamicLink: dynamicLink ?? this.dynamicLink,
        isfavourite: isfavourite ?? this.isfavourite,
        storeAddresses: storeAddresses ?? this.storeAddresses,
        storeTimings: storeTimings ?? this.storeTimings,
        storeDeliveryServices:
            storeDeliveryServices ?? this.storeDeliveryServices,
        storePages: storePages ?? this.storePages,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
        logo: json["logo"] == null ? null : Images.fromJson(json["logo"]),
        isFavouriteStore: json["is_favourite_store"],
        storeId: json["store_id"],
        storeName: json["store_name"],
        storeEin: json["store_ein"],
        storeNickName: json["store_nick_name"],
        storePhoneCode: json["store_phone_code"],
        storeEmail: json["store_email"],
        storePhone: json["store_phone"],
        isVerified: json["is_verified"],
        isEnabled: json["is_enabled"],
        dynamicLink: json["dynamic_link"],
        isfavourite: json["isfavourite"],
        storeAddresses: json["store_addresses"] == null
            ? []
            : List<StoreAddress>.from(
                json["store_addresses"]!.map((x) => StoreAddress.fromJson(x))),
        storeTimings: json["store_timings"] == null
            ? []
            : List<StoreTiming>.from(
                json["store_timings"]!.map((x) => StoreTiming.fromJson(x))),
        storeDeliveryServices: json["store_delivery_services"] == null
            ? []
            : List<StoreDeliveryService>.from(json["store_delivery_services"]!
                .map((x) => StoreDeliveryService.fromJson(x))),
        storePages: json["store_pages"] == null
            ? []
            : List<StorePage>.from(
                json["store_pages"]!.map((x) => StorePage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "logo": logo?.toJson(),
        "is_favourite_store": isFavouriteStore,
        "store_id": storeId,
        "store_name": storeName,
        "store_ein": storeEin,
        "store_nick_name": storeNickName,
        "store_phone_code": storePhoneCode,
        "store_email": storeEmail,
        "store_phone": storePhone,
        "is_verified": isVerified,
        "is_enabled": isEnabled,
        "dynamic_link": dynamicLink,
        "isfavourite": isfavourite,
        "store_addresses": storeAddresses == null
            ? []
            : List<dynamic>.from(storeAddresses!.map((x) => x.toJson())),
        "store_timings": storeTimings == null
            ? []
            : List<dynamic>.from(storeTimings!.map((x) => x.toJson())),
        "store_delivery_services": storeDeliveryServices == null
            ? []
            : List<dynamic>.from(storeDeliveryServices!.map((x) => x.toJson())),
        "store_pages": storePages == null
            ? []
            : List<dynamic>.from(storePages!.map((x) => x.toJson())),
      };
}

class StorePage {
  String? storeId;
  String? storePageType;
  Images? storePageContent;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? storePageId;

  StorePage({
    this.storeId,
    this.storePageType,
    this.storePageContent,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.storePageId,
  });

  StorePage copyWith({
    String? storeId,
    String? storePageType,
    Images? storePageContent,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? storePageId,
  }) =>
      StorePage(
        storeId: storeId ?? this.storeId,
        storePageType: storePageType ?? this.storePageType,
        storePageContent: storePageContent ?? this.storePageContent,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        storePageId: storePageId ?? this.storePageId,
      );

  factory StorePage.fromJson(Map<String, dynamic> json) => StorePage(
        storeId: json["store_id"],
        storePageType: json["store_page_type"],
        storePageContent: json["store_page_content"] == null
            ? null
            : Images.fromJson(json["store_page_content"]),
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        storePageId: json["store_page_id"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_page_type": storePageType,
        "store_page_content": storePageContent?.toJson(),
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "store_page_id": storePageId,
      };
}

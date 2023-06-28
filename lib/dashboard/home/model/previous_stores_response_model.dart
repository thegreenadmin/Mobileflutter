// To parse this JSON data, do
//
//     final previousStoreResponse = previousStoreResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

PreviousStoreResponse previousStoreResponseFromJson(String str) =>
    PreviousStoreResponse.fromJson(json.decode(str));

String previousStoreResponseToJson(PreviousStoreResponse data) =>
    json.encode(data.toJson());

class PreviousStoreResponse {
  int? status;
  String? message;
  PreviousStoreData? data;

  PreviousStoreResponse({
    this.status,
    this.message,
    this.data,
  });

  PreviousStoreResponse copyWith({
    int? status,
    String? message,
    PreviousStoreData? data,
  }) =>
      PreviousStoreResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PreviousStoreResponse.fromJson(Map<String, dynamic> json) =>
      PreviousStoreResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PreviousStoreData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class PreviousStoreData {
  int? totalCount;
  List<PreviousStore>? previousStores;

  PreviousStoreData({
    this.totalCount,
    this.previousStores,
  });

  PreviousStoreData copyWith({
    int? totalCount,
    List<PreviousStore>? previousStores,
  }) =>
      PreviousStoreData(
        totalCount: totalCount ?? this.totalCount,
        previousStores: previousStores ?? this.previousStores,
      );

  factory PreviousStoreData.fromJson(Map<String, dynamic> json) =>
      PreviousStoreData(
        totalCount: json["total_count"],
        previousStores: json["previous_stores"] == null
            ? []
            : List<PreviousStore>.from(
                json["previous_stores"]!.map((x) => PreviousStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "previous_stores": previousStores == null
            ? []
            : List<dynamic>.from(previousStores!.map((x) => x.toJson())),
      };
}

class PreviousStore {
  String? dynamicLink;
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storeEmail;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  dynamic verifiedBy;
  bool? isEnabled;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? storeId;
  List<PreviousStoreTiming>? storeTimings;
  List<PreviousStoreAddress>? storeAddresses;
  List<PreviousStoreDeliveryService>? storeDeliveryServices;
  Images? logo;
  Images? image;
  bool? isFavouriteStore;
  bool? hasStoreOwner;

  PreviousStore({
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
    this.storeTimings,
    this.storeAddresses,
    this.storeDeliveryServices,
    this.logo,
    this.image,
    this.isFavouriteStore,
    this.hasStoreOwner,
  });

  PreviousStore copyWith({
    String? dynamicLink,
    String? storeName,
    String? storeEin,
    String? storeNickName,
    String? storeEmail,
    String? storePhone,
    String? storePhoneCode,
    bool? isVerified,
    dynamic verifiedBy,
    bool? isEnabled,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? storeId,
    List<PreviousStoreTiming>? storeTimings,
    List<PreviousStoreAddress>? storeAddresses,
    List<PreviousStoreDeliveryService>? storeDeliveryServices,
    Images? logo,
    Images? image,
    bool? isFavouriteStore,
    bool? hasStoreOwner,
  }) =>
      PreviousStore(
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
        storeTimings: storeTimings ?? this.storeTimings,
        storeAddresses: storeAddresses ?? this.storeAddresses,
        storeDeliveryServices:
            storeDeliveryServices ?? this.storeDeliveryServices,
        logo: logo ?? this.logo,
        image: image ?? this.image,
        isFavouriteStore: isFavouriteStore ?? this.isFavouriteStore,
        hasStoreOwner: hasStoreOwner ?? this.hasStoreOwner,
      );

  factory PreviousStore.fromJson(Map<String, dynamic> json) => PreviousStore(
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
        storeTimings: json["store_timings"] == null
            ? []
            : List<PreviousStoreTiming>.from(json["store_timings"]!
                .map((x) => PreviousStoreTiming.fromJson(x))),
        storeAddresses: json["store_addresses"] == null
            ? []
            : List<PreviousStoreAddress>.from(json["store_addresses"]!
                .map((x) => PreviousStoreAddress.fromJson(x))),
        storeDeliveryServices: json["store_delivery_services"] == null
            ? []
            : List<PreviousStoreDeliveryService>.from(
                json["store_delivery_services"]!
                    .map((x) => PreviousStoreDeliveryService.fromJson(x))),
        logo: json["logo"] == null ? null : Images.fromJson(json["logo"]),
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
        isFavouriteStore: json["is_favourite_store"],
        hasStoreOwner: json["has_store_owner"],
      );

  Map<String, dynamic> toJson() => {
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
        "store_timings": storeTimings == null
            ? []
            : List<dynamic>.from(storeTimings!.map((x) => x.toJson())),
        "store_addresses": storeAddresses == null
            ? []
            : List<dynamic>.from(storeAddresses!.map((x) => x.toJson())),
        "store_delivery_services": storeDeliveryServices == null
            ? []
            : List<dynamic>.from(storeDeliveryServices!.map((x) => x.toJson())),
        "logo": logo?.toJson(),
        "image": image?.toJson(),
        "is_favourite_store": isFavouriteStore,
        "has_store_owner": hasStoreOwner,
      };
}

class PreviousStoreAddress {
  String? id;
  String? storeId;
  String? stateId;
  String? addressName;
  double? longitude;
  double? latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  PreviousStoreAddress({
    this.id,
    this.storeId,
    this.stateId,
    this.addressName,
    this.longitude,
    this.latitude,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.postalCode,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  PreviousStoreAddress copyWith({
    String? id,
    String? storeId,
    String? stateId,
    String? addressName,
    double? longitude,
    double? latitude,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? city,
    String? postalCode,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PreviousStoreAddress(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        stateId: stateId ?? this.stateId,
        addressName: addressName ?? this.addressName,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        landmark: landmark ?? this.landmark,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PreviousStoreAddress.fromJson(Map<String, dynamic> json) =>
      PreviousStoreAddress(
        id: json["id"],
        storeId: json["store_id"],
        stateId: json["state_id"],
        addressName: json["address_name"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        landmark: json["landmark"],
        city: json["city"],
        postalCode: json["postal_code"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "state_id": stateId,
        "address_name": addressName,
        "longitude": longitude,
        "latitude": latitude,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "landmark": landmark,
        "city": city,
        "postal_code": postalCode,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class PreviousStoreDeliveryService {
  String? storeDeliveryServiceId;
  String? deliveryServiceId;
  bool? isEnabled;
  String? status;
  String? deliveryServiceName;

  PreviousStoreDeliveryService({
    this.storeDeliveryServiceId,
    this.deliveryServiceId,
    this.isEnabled,
    this.status,
    this.deliveryServiceName,
  });

  PreviousStoreDeliveryService copyWith({
    String? storeDeliveryServiceId,
    String? deliveryServiceId,
    bool? isEnabled,
    String? status,
    String? deliveryServiceName,
  }) =>
      PreviousStoreDeliveryService(
        storeDeliveryServiceId:
            storeDeliveryServiceId ?? this.storeDeliveryServiceId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        deliveryServiceName: deliveryServiceName ?? this.deliveryServiceName,
      );

  factory PreviousStoreDeliveryService.fromJson(Map<String, dynamic> json) =>
      PreviousStoreDeliveryService(
        storeDeliveryServiceId: json["store_delivery_service_id"],
        deliveryServiceId: json["delivery_service_id"],
        isEnabled: json["is_enabled"],
        status: json["status"],
        deliveryServiceName: json["delivery_service_name"],
      );

  Map<String, dynamic> toJson() => {
        "store_delivery_service_id": storeDeliveryServiceId,
        "delivery_service_id": deliveryServiceId,
        "is_enabled": isEnabled,
        "status": status,
        "delivery_service_name": deliveryServiceName,
      };
}

class PreviousStoreTiming {
  String? storeTimingId;
  bool? is24HoursActive;
  int? dayOfWeek;
  String? openingTime;
  String? closingTime;
  String? status;

  PreviousStoreTiming({
    this.storeTimingId,
    this.is24HoursActive,
    this.dayOfWeek,
    this.openingTime,
    this.closingTime,
    this.status,
  });

  PreviousStoreTiming copyWith({
    String? storeTimingId,
    bool? is24HoursActive,
    int? dayOfWeek,
    String? openingTime,
    String? closingTime,
    String? status,
  }) =>
      PreviousStoreTiming(
        storeTimingId: storeTimingId ?? this.storeTimingId,
        is24HoursActive: is24HoursActive ?? this.is24HoursActive,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        openingTime: openingTime ?? this.openingTime,
        closingTime: closingTime ?? this.closingTime,
        status: status ?? this.status,
      );

  factory PreviousStoreTiming.fromJson(Map<String, dynamic> json) =>
      PreviousStoreTiming(
        storeTimingId: json["store_timing_id"],
        is24HoursActive: json["is_24_hours_active"],
        dayOfWeek: json["day_of_week"],
        openingTime: json["opening_time"],
        closingTime: json["closing_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "store_timing_id": storeTimingId,
        "is_24_hours_active": is24HoursActive,
        "day_of_week": dayOfWeek,
        "opening_time": openingTime,
        "closing_time": closingTime,
        "status": status,
      };
}

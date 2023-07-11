// To parse this JSON data, do
//
//     final nearbyStoreListResponse = nearbyStoreListResponseFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

NearbyStoreListResponse nearbyStoreListResponseFromJson(String str) =>
    NearbyStoreListResponse.fromJson(json.decode(str));

String nearbyStoreListResponseToJson(NearbyStoreListResponse data) =>
    json.encode(data.toJson());

class NearbyStoreListResponse {
  NearbyStoreListResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  NearbyStoreData? data;

  NearbyStoreListResponse copyWith({
    dynamic status,
    String? message,
    NearbyStoreData? data,
  }) =>
      NearbyStoreListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory NearbyStoreListResponse.fromJson(Map<String, dynamic> json) =>
      NearbyStoreListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : NearbyStoreData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class NearbyStoreData {
  NearbyStoreData({
    this.totalCount,
    this.storeAddresses,
  });

  dynamic totalCount;
  List<StoreAddress>? storeAddresses;

  NearbyStoreData copyWith({
    dynamic totalCount,
    List<StoreAddress>? storeAddresses,
  }) =>
      NearbyStoreData(
        totalCount: totalCount ?? this.totalCount,
        storeAddresses: storeAddresses ?? this.storeAddresses,
      );

  factory NearbyStoreData.fromJson(Map<String, dynamic> json) =>
      NearbyStoreData(
        totalCount: json["total_count"],
        storeAddresses: json["store_addresses"] == null
            ? []
            : List<StoreAddress>.from(
                json["store_addresses"]!.map((x) => StoreAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "store_addresses": storeAddresses == null
            ? []
            : List<dynamic>.from(storeAddresses!.map((x) => x.toJson())),
      };
}

class StoreAddress {
  StoreAddress({
    this.storeAddressId,
    this.addressName,
    this.longitude,
    this.latitude,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.postalCode,
    this.distance,
    this.store,
    this.state,
  });

  String? storeAddressId;
  String? addressName;
  double? longitude;
  double? latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  double? distance;
  NearbyStore? store;
  State? state;

  StoreAddress copyWith({
    String? storeAddressId,
    String? addressName,
    double? longitude,
    double? latitude,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? city,
    String? postalCode,
    double? distance,
    NearbyStore? store,
    State? state,
  }) =>
      StoreAddress(
        storeAddressId: storeAddressId ?? this.storeAddressId,
        addressName: addressName ?? this.addressName,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        landmark: landmark ?? this.landmark,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        distance: distance ?? this.distance,
        store: store ?? this.store,
        state: state ?? this.state,
      );

  factory StoreAddress.fromJson(Map<String, dynamic> json) => StoreAddress(
        storeAddressId: json["store_address_id"],
        addressName: json["address_name"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        landmark: json["landmark"],
        city: json["city"],
        postalCode: json["postal_code"],
        distance: json["distance"]?.toDouble(),
        store:
            json["store"] == null ? null : NearbyStore.fromJson(json["store"]),
        state: json["state"] == null ? null : State.fromJson(json["state"]),
      );

  Map<String, dynamic> toJson() => {
        "store_address_id": storeAddressId,
        "address_name": addressName,
        "longitude": longitude,
        "latitude": latitude,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "landmark": landmark,
        "city": city,
        "postal_code": postalCode,
        "distance": distance,
        "store": store?.toJson(),
        "state": state?.toJson(),
      };
}

class NearbyStore {
  NearbyStore({
    this.logo,
    this.image,
    this.hasStoreOwner,
    this.isFavouriteStore,
    this.storeId,
    this.storeName,
    this.isVerified,
    this.isEnabled,
    this.storeTimings,
    this.storeDeliveryServices,
  });

  Images? logo;
  Images? image;
  bool? hasStoreOwner;
  bool? isFavouriteStore;
  String? storeId;
  String? storeName;
  bool? isVerified;
  bool? isEnabled;
  List<StoreTiming>? storeTimings;
  List<StoreDeliveryService>? storeDeliveryServices;

  NearbyStore copyWith({
    Images? logo,
    Images? image,
    bool? hasStoreOwner,
    bool? isFavouriteStore,
    String? storeId,
    String? storeName,
    bool? isVerified,
    bool? isEnabled,
    List<StoreTiming>? storeTimings,
    List<StoreDeliveryService>? storeDeliveryServices,
  }) =>
      NearbyStore(
        logo: logo ?? this.logo,
        image: image ?? this.image,
        hasStoreOwner: hasStoreOwner ?? this.hasStoreOwner,
        isFavouriteStore: isFavouriteStore ?? this.isFavouriteStore,
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        isVerified: isVerified ?? this.isVerified,
        isEnabled: isEnabled ?? this.isEnabled,
        storeTimings: storeTimings ?? this.storeTimings,
        storeDeliveryServices:
            storeDeliveryServices ?? this.storeDeliveryServices,
      );

  factory NearbyStore.fromJson(Map<String, dynamic> json) => NearbyStore(
        logo: json["logo"] == null ? null : Images.fromJson(json["logo"]),
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
        hasStoreOwner: json["has_store_owner"],
        isFavouriteStore: json["is_favourite_store"],
        storeId: json["store_id"],
        storeName: json["store_name"],
        isVerified: json["is_verified"],
        isEnabled: json["is_enabled"],
        storeTimings: json["store_timings"] == null
            ? []
            : List<StoreTiming>.from(
                json["store_timings"]!.map((x) => StoreTiming.fromJson(x))),
        storeDeliveryServices: json["store_delivery_services"] == null
            ? []
            : List<StoreDeliveryService>.from(json["store_delivery_services"]!
                .map((x) => StoreDeliveryService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "logo": logo?.toJson(),
        "image": image?.toJson(),
        "has_store_owner": hasStoreOwner,
        "is_favourite_store": isFavouriteStore,
        "store_id": storeId,
        "store_name": storeName,
        "is_verified": isVerified,
        "is_enabled": isEnabled,
        "store_timings": storeTimings == null
            ? []
            : List<dynamic>.from(storeTimings!.map((x) => x.toJson())),
        "store_delivery_services": storeDeliveryServices == null
            ? []
            : List<dynamic>.from(storeDeliveryServices!.map((x) => x.toJson())),
      };
}





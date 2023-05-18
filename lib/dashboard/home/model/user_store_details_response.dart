// To parse this JSON data, do
//
//     final storeDetailsResponse = storeDetailsResponseFromJson(jsonString);

import 'dart:convert';

StoreDetailsResponse storeDetailsResponseFromJson(String str) =>
    StoreDetailsResponse.fromJson(json.decode(str));

String storeDetailsResponseToJson(StoreDetailsResponse data) =>
    json.encode(data.toJson());

class StoreDetailsResponse {
  int? status;
  String? message;
  Data? data;

  StoreDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  StoreDetailsResponse copyWith({
    int? status,
    String? message,
    Data? data,
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
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Store? store;

  Data({
    this.store,
  });

  Data copyWith({
    Store? store,
  }) =>
      Data(
        store: store ?? this.store,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "store": store?.toJson(),
      };
}

class Store {
  Image? image;
  Image? logo;
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
    Image? image,
    Image? logo,
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
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        logo: json["logo"] == null ? null : Image.fromJson(json["logo"]),
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

class Image {
  String? orignalUrl;
  String? dynamicUrl;

  Image({
    this.orignalUrl,
    this.dynamicUrl,
  });

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

class StoreAddress {
  String? storeAddressId;
  String? addressName;
  double? longitude;
  double? latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  State? state;

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
    this.state,
  });

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
        "state": state?.toJson(),
      };
}

class State {
  String? stateId;
  String? stateName;
  Country? country;

  State({
    this.stateId,
    this.stateName,
    this.country,
  });

  State copyWith({
    String? stateId,
    String? stateName,
    Country? country,
  }) =>
      State(
        stateId: stateId ?? this.stateId,
        stateName: stateName ?? this.stateName,
        country: country ?? this.country,
      );

  factory State.fromJson(Map<String, dynamic> json) => State(
        stateId: json["state_id"],
        stateName: json["state_name"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "state_id": stateId,
        "state_name": stateName,
        "country": country?.toJson(),
      };
}

class Country {
  String? countryId;
  String? countryName;

  Country({
    this.countryId,
    this.countryName,
  });

  Country copyWith({
    String? countryId,
    String? countryName,
  }) =>
      Country(
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
      );

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryId: json["country_id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId,
        "country_name": countryName,
      };
}

class StoreDeliveryService {
  String? storeDeliveryServiceId;
  String? deliveryServiceId;
  bool? isEnabled;
  String? status;

  StoreDeliveryService({
    this.storeDeliveryServiceId,
    this.deliveryServiceId,
    this.isEnabled,
    this.status,
  });

  StoreDeliveryService copyWith({
    String? storeDeliveryServiceId,
    String? deliveryServiceId,
    bool? isEnabled,
    String? status,
  }) =>
      StoreDeliveryService(
        storeDeliveryServiceId:
            storeDeliveryServiceId ?? this.storeDeliveryServiceId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
      );

  factory StoreDeliveryService.fromJson(Map<String, dynamic> json) =>
      StoreDeliveryService(
        storeDeliveryServiceId: json["store_delivery_service_id"],
        deliveryServiceId: json["delivery_service_id"],
        isEnabled: json["is_enabled"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "store_delivery_service_id": storeDeliveryServiceId,
        "delivery_service_id": deliveryServiceId,
        "is_enabled": isEnabled,
        "status": status,
      };
}

class StorePage {
    String? storeId;
    String? storePageType;
    Image? storePageContent;
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
        Image? storePageContent,
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
        storePageContent: json["store_page_content"] == null ? null : Image.fromJson(json["store_page_content"]),
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

class StoreTiming {
  String? storeTimingId;
  bool? is24HoursActive;
  int? dayOfWeek;
  String? openingTime;
  String? closingTime;
  String? status;

  StoreTiming({
    this.storeTimingId,
    this.is24HoursActive,
    this.dayOfWeek,
    this.openingTime,
    this.closingTime,
    this.status,
  });

  StoreTiming copyWith({
    String? storeTimingId,
    bool? is24HoursActive,
    int? dayOfWeek,
    String? openingTime,
    String? closingTime,
    String? status,
  }) =>
      StoreTiming(
        storeTimingId: storeTimingId ?? this.storeTimingId,
        is24HoursActive: is24HoursActive ?? this.is24HoursActive,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        openingTime: openingTime ?? this.openingTime,
        closingTime: closingTime ?? this.closingTime,
        status: status ?? this.status,
      );

  factory StoreTiming.fromJson(Map<String, dynamic> json) => StoreTiming(
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

// To parse this JSON data, do
//
//     final storeDetailsResponse = storeDetailsResponseFromJson(jsonString);

import 'dart:convert';

StoreDetailsResponse storeDetailsResponseFromJson(String str) => StoreDetailsResponse.fromJson(json.decode(str));

String storeDetailsResponseToJson(StoreDetailsResponse data) => json.encode(data.toJson());

class StoreDetailsResponse {
  StoreDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

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

  factory StoreDetailsResponse.fromJson(Map<String, dynamic> json) => StoreDetailsResponse(
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
    this.store,
  });

  Store? store;

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
  Store({
    this.image,
    this.logo,
    this.storeId,
    this.storeName,
    this.storeEin,
    this.storeNickName,
    this.storePhoneCode,
    this.storeEmail,
    this.storePhone,
    this.isVerified,
    this.isEnabled,
    this.storeAddresses,
    this.storeTimings,
    this.storeDeliveryServices,
  });

  Image? image;
  Image? logo;
  String? storeId;
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storePhoneCode;
  String? storeEmail;
  String? storePhone;
  bool? isVerified;
  bool? isEnabled;
  List<StoreAddress>? storeAddresses;
  List<StoreTiming>? storeTimings;
  List<StoreDeliveryService>? storeDeliveryServices;

  Store copyWith({
    Image? image,
    Image? logo,
    String? storeId,
    String? storeName,
    String? storeEin,
    String? storeNickName,
    String? storePhoneCode,
    String? storeEmail,
    String? storePhone,
    bool? isVerified,
    bool? isEnabled,
    List<StoreAddress>? storeAddresses,
    List<StoreTiming>? storeTimings,
    List<StoreDeliveryService>? storeDeliveryServices,
  }) =>
      Store(
        image: image ?? this.image,
        logo: logo ?? this.logo,
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        storeEin: storeEin ?? this.storeEin,
        storeNickName: storeNickName ?? this.storeNickName,
        storePhoneCode: storePhoneCode ?? this.storePhoneCode,
        storeEmail: storeEmail ?? this.storeEmail,
        storePhone: storePhone ?? this.storePhone,
        isVerified: isVerified ?? this.isVerified,
        isEnabled: isEnabled ?? this.isEnabled,
        storeAddresses: storeAddresses ?? this.storeAddresses,
        storeTimings: storeTimings ?? this.storeTimings,
        storeDeliveryServices: storeDeliveryServices ?? this.storeDeliveryServices,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    logo: json["logo"] == null ? null : Image.fromJson(json["logo"]),
    storeId: json["store_id"],
    storeName: json["store_name"],
    storeEin: json["store_ein"],
    storeNickName: json["store_nick_name"],
    storePhoneCode: json["store_phone_code"],
    storeEmail: json["store_email"],
    storePhone: json["store_phone"],
    isVerified: json["is_verified"],
    isEnabled: json["is_enabled"],
    storeAddresses: json["store_addresses"] == null ? [] : List<StoreAddress>.from(json["store_addresses"]!.map((x) => StoreAddress.fromJson(x))),
    storeTimings: json["store_timings"] == null ? [] : List<StoreTiming>.from(json["store_timings"]!.map((x) => StoreTiming.fromJson(x))),
    storeDeliveryServices: json["store_delivery_services"] == null ? [] : List<StoreDeliveryService>.from(json["store_delivery_services"]!.map((x) => StoreDeliveryService.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "image": image?.toJson(),
    "logo": logo?.toJson(),
    "store_id": storeId,
    "store_name": storeName,
    "store_ein": storeEin,
    "store_nick_name": storeNickName,
    "store_phone_code": storePhoneCode,
    "store_email": storeEmail,
    "store_phone": storePhone,
    "is_verified": isVerified,
    "is_enabled": isEnabled,
    "store_addresses": storeAddresses == null ? [] : List<dynamic>.from(storeAddresses!.map((x) => x.toJson())),
    "store_timings": storeTimings == null ? [] : List<dynamic>.from(storeTimings!.map((x) => x.toJson())),
    "store_delivery_services": storeDeliveryServices == null ? [] : List<dynamic>.from(storeDeliveryServices!.map((x) => x.toJson())),
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
  State({
    this.stateId,
    this.stateName,
    this.country,
  });

  String? stateId;
  String? stateName;
  Country? country;

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
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
  );

  Map<String, dynamic> toJson() => {
    "state_id": stateId,
    "state_name": stateName,
    "country": country?.toJson(),
  };
}

class Country {
  Country({
    this.countryId,
    this.countryName,
  });

  String? countryId;
  String? countryName;

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
  StoreDeliveryService({
    this.storeDeliveryServiceId,
    this.deliveryServiceId,
    this.isEnabled,
    this.status,
  });

  String? storeDeliveryServiceId;
  String? deliveryServiceId;
  bool? isEnabled;
  String? status;

  StoreDeliveryService copyWith({
    String? storeDeliveryServiceId,
    String? deliveryServiceId,
    bool? isEnabled,
    String? status,
  }) =>
      StoreDeliveryService(
        storeDeliveryServiceId: storeDeliveryServiceId ?? this.storeDeliveryServiceId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
      );

  factory StoreDeliveryService.fromJson(Map<String, dynamic> json) => StoreDeliveryService(
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

class StoreTiming {
  StoreTiming({
    this.storeTimingId,
    this.is24HoursActive,
    this.dayOfWeek,
    this.openingTime,
    this.closingTime,
    this.status,
  });

  String? storeTimingId;
  bool? is24HoursActive;
  int? dayOfWeek;
  String? openingTime;
  String? closingTime;
  String? status;

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

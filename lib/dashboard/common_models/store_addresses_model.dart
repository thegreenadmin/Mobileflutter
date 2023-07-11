import '../home/model/model.dart';

class StoreAddresses {
  StoreAddresses({
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
  dynamic longitude;
  dynamic latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  dynamic distance;
  NearbyStore? store;
  State? state;

  StoreAddresses copyWith({
    String? storeAddressId,
    String? addressName,
    dynamic longitude,
    dynamic latitude,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? city,
    String? postalCode,
    dynamic distance,
    NearbyStore? store,
    State? state,
  }) =>
      StoreAddresses(
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

  factory StoreAddresses.fromJson(Map<String, dynamic> json) => StoreAddresses(
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


class State {
  String? stateId;
  String? stateName;
  Country? country;

  State({stateId, this.stateName, this.country});

  State.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}

class Country {
  String? countryId;
  String? countryName;

  Country({this.countryId, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    return data;
  }
}

class Offer {
  Offer({
    this.storeId,
    this.isOfferForStore,
    this.offerName,
    this.offerType,
    this.offerValue,
    this.isExpired,
    this.expiredAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.offerId,
    this.imageUrl,
    this.image,
  });

  String? storeId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  dynamic offerValue;
  bool? isExpired;
  dynamic expiredAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? offerId;
  String? imageUrl;
  Images? image;

  Offer copyWith({
    String? storeId,
    bool? isOfferForStore,
    String? offerName,
    String? offerType,
    dynamic offerValue,
    bool? isExpired,
    dynamic expiredAt,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? offerId,
    String? imageUrl,
    Images? image,
  }) =>
      Offer(
        storeId: storeId ?? this.storeId,
        isOfferForStore: isOfferForStore ?? this.isOfferForStore,
        offerName: offerName ?? this.offerName,
        offerType: offerType ?? this.offerType,
        offerValue: offerValue ?? this.offerValue,
        isExpired: isExpired ?? this.isExpired,
        expiredAt: expiredAt ?? this.expiredAt,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        offerId: offerId ?? this.offerId,
        imageUrl: imageUrl ?? this.imageUrl,
        image: image ?? this.image,
      );

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        storeId: json["store_id"],
        isOfferForStore: json["is_offer_for_store"],
        offerName: json["offer_name"],
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
        imageUrl: json["image_url"],
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "is_offer_for_store": isOfferForStore,
        "offer_name": offerName,
        "offer_type": offerType,
        "offer_value": offerValue,
        "is_expired": isExpired,
        "expiredAt": expiredAt,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "offer_id": offerId,
        "image_url": imageUrl,
        "image": image?.toJson(),
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



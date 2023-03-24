// To parse this JSON data, do
//
//     final storeOffersListResponse = storeOffersListResponseFromJson(jsonString);

import 'dart:convert';

StoreOffersListResponse storeOffersListResponseFromJson(String str) => StoreOffersListResponse.fromJson(json.decode(str));

String storeOffersListResponseToJson(StoreOffersListResponse data) => json.encode(data.toJson());

class StoreOffersListResponse {
  StoreOffersListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  StoreOffersListResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      StoreOffersListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreOffersListResponse.fromJson(Map<String, dynamic> json) => StoreOffersListResponse(
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
    this.offers,
  });

  List<Offer>? offers;

  Data copyWith({
    List<Offer>? offers,
  }) =>
      Data(
        offers: offers ?? this.offers,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    offers: json["offers"] == null ? [] : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "offers": offers == null ? [] : List<dynamic>.from(offers!.map((x) => x.toJson())),
  };
}

class Offer {
  Offer({
    this.image,
    this.offerId,
    this.isOfferForStore,
    this.offerName,
    this.isExpired,
    this.createdAt,
    this.status,
  });

  Image? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  bool? isExpired;
  DateTime? createdAt;
  String? status;

  Offer copyWith({
    Image? image,
    String? offerId,
    bool? isOfferForStore,
    String? offerName,
    bool? isExpired,
    DateTime? createdAt,
    String? status,
  }) =>
      Offer(
        image: image ?? this.image,
        offerId: offerId ?? this.offerId,
        isOfferForStore: isOfferForStore ?? this.isOfferForStore,
        offerName: offerName ?? this.offerName,
        isExpired: isExpired ?? this.isExpired,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
      );

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    offerId: json["offer_id"],
    isOfferForStore: json["is_offer_for_store"],
    offerName: json["offer_name"],
    isExpired: json["is_expired"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "image": image?.toJson(),
    "offer_id": offerId,
    "is_offer_for_store": isOfferForStore,
    "offer_name": offerName,
    "is_expired": isExpired,
    "createdAt": createdAt?.toIso8601String(),
    "status": status,
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

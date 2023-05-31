class GetUserOfferListModel {
  int? status;
  String? message;
  Data? data;

  GetUserOfferListModel({this.status, this.message, this.data});

  GetUserOfferListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalCount;
  List<Stores>? stores;

  Data({this.totalCount, this.stores});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  Logo? logo;
  String? storeId;
  String? storeName;
  bool? isVerified;
  bool? isEnabled;
  List<StoreAddresses>? storeAddresses;
  List<Offers>? offers;

  Stores(
      {this.logo,
      this.storeId,
      this.storeName,
      this.isVerified,
      this.isEnabled,
      this.storeAddresses,
      this.offers});

  Stores.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    storeId = json['store_id'];
    storeName = json['store_name'];
    isVerified = json['is_verified'];
    isEnabled = json['is_enabled'];
    if (json['store_addresses'] != null) {
      storeAddresses = <StoreAddresses>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(StoreAddresses.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (logo != null) {
      data['logo'] = logo!.toJson();
    }
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['is_verified'] = isVerified;
    data['is_enabled'] = isEnabled;
    if (storeAddresses != null) {
      data['store_addresses'] = storeAddresses!.map((v) => v.toJson()).toList();
    }
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Logo {
  String? orignalUrl;
  String? dynamicUrl;

  Logo({this.orignalUrl, this.dynamicUrl});

  Logo.fromJson(Map<String, dynamic> json) {
    orignalUrl = json['orignal_url'];
    dynamicUrl = json['dynamic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orignal_url'] = orignalUrl;
    data['dynamic_url'] = dynamicUrl;
    return data;
  }
}

class StoreAddresses {
  String? storeAddressId;
  String? addressName;
  double? longitude;
  double? latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  dynamic distance;

  StoreAddresses(
      {this.storeAddressId,
      this.addressName,
      this.longitude,
      this.latitude,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.postalCode,
      this.distance});

  StoreAddresses.fromJson(Map<String, dynamic> json) {
    storeAddressId = json['store_address_id'];
    addressName = json['address_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    postalCode = json['postal_code'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['store_address_id'] = storeAddressId;
    data['address_name'] = addressName;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['landmark'] = landmark;
    data['city'] = city;
    data['postal_code'] = postalCode;
    data['distance'] = distance;
    return data;
  }
}

class Offers {
  Logo? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  int? offerValue;
  bool? isExpired;
  String? expiredAt;

  Offers(
      {this.image,
      this.offerId,
      this.isOfferForStore,
      this.offerName,
      this.offerType,
      this.offerValue,
      this.isExpired,
      this.expiredAt});

  Offers.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Logo.fromJson(json['image']) : null;
    offerId = json['offer_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
    isExpired = json['is_expired'];
    expiredAt = json['expiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['offer_id'] = offerId;
    data['is_offer_for_store'] = isOfferForStore;
    data['offer_name'] = offerName;
    data['offer_type'] = offerType;
    data['offer_value'] = offerValue;
    data['is_expired'] = isExpired;
    data['expiredAt'] = expiredAt;
    return data;
  }
}

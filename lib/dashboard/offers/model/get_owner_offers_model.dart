class GetOwnerOffersListModel {
  int? status;
  String? message;
  Data? data;

  GetOwnerOffersListModel({this.status, this.message, this.data});

  GetOwnerOffersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalCount;
  List<OffersList>? offers;

  Data({this.totalCount, this.offers});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['offers'] != null) {
      offers = <OffersList>[];
      json['offers'].forEach((v) {
        offers!.add(OffersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OffersList {
  Image? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  int? offerValue;
  bool? isExpired;
  String? expiredAt;
  Store? store;

  OffersList(
      {this.image,
      this.offerId,
      this.isOfferForStore,
      this.offerName,
      this.offerType,
      this.offerValue,
      this.isExpired,
      this.expiredAt,
      this.store});

  OffersList.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    offerId = json['offer_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
    isExpired = json['is_expired'];
    expiredAt = json['expiredAt'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
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
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

class Image {
  String? orignalUrl;
  String? dynamicUrl;

  Image({this.orignalUrl, this.dynamicUrl});

  Image.fromJson(Map<String, dynamic> json) {
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

class Store {
  Image? logo;
  String? storeId;
  String? storeName;
  List<StoreAddresse>? storeAddresses;

  Store({this.logo, this.storeId, this.storeName, this.storeAddresses});

  Store.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] != null ? Image.fromJson(json['logo']) : null;
    storeId = json['store_id'];
    storeName = json['store_name'];
    if (json['store_addresses'] != null) {
      storeAddresses = <StoreAddresse>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(StoreAddresse.fromJson(v));
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
    if (storeAddresses != null) {
      data['store_addresses'] = storeAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoreAddresse {
  String? storeAddressId;
  String? addressName;
  double? longitude;
  double? latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  State? state;

  StoreAddresse(
      {this.storeAddressId,
      this.addressName,
      this.longitude,
      this.latitude,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.state});

  StoreAddresse.fromJson(Map<String, dynamic> json) {
    storeAddressId = json['store_address_id'];
    addressName = json['address_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'] != null ? State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_address_id'] = storeAddressId;
    data['address_name'] = addressName;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['landmark'] = landmark;
    data['city'] = city;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}

class State {
  String? stateId;
  String? stateName;
  Country? country;

  State({this.stateId, this.stateName, this.country});

  State.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    return data;
  }
}

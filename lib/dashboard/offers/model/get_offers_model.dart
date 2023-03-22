class GetOffersListModel {
  int? status;
  String? message;
  Data? data;

  GetOffersListModel({this.status, this.message, this.data});

  GetOffersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalCount;
  List<Offers>? offers;

  Data({this.totalCount, this.offers});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offers {
  Image? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  int? offerValue;
  bool? isExpired;
  String? expiredAt;
  Store? store;

  Offers(
      {this.image,
      this.offerId,
      this.isOfferForStore,
      this.offerName,
      this.offerType,
      this.offerValue,
      this.isExpired,
      this.expiredAt,
      this.store});

  Offers.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    offerId = json['offer_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
    isExpired = json['is_expired'];
    expiredAt = json['expiredAt'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['offer_id'] = this.offerId;
    data['is_offer_for_store'] = this.isOfferForStore;
    data['offer_name'] = this.offerName;
    data['offer_type'] = this.offerType;
    data['offer_value'] = this.offerValue;
    data['is_expired'] = this.isExpired;
    data['expiredAt'] = this.expiredAt;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orignal_url'] = this.orignalUrl;
    data['dynamic_url'] = this.dynamicUrl;
    return data;
  }
}

class Store {
  Image? logo;
  String? storeId;
  String? storeName;
  List<StoreAddresses>? storeAddresses;

  Store({this.logo, this.storeId, this.storeName, this.storeAddresses});

  Store.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] != null ? new Image.fromJson(json['logo']) : null;
    storeId = json['store_id'];
    storeName = json['store_name'];
    if (json['store_addresses'] != null) {
      storeAddresses = <StoreAddresses>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(new StoreAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    if (this.storeAddresses != null) {
      data['store_addresses'] =
          this.storeAddresses!.map((v) => v.toJson()).toList();
    }
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
  State? state;

  StoreAddresses(
      {this.storeAddressId,
      this.addressName,
      this.longitude,
      this.latitude,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.state});

  StoreAddresses.fromJson(Map<String, dynamic> json) {
    storeAddressId = json['store_address_id'];
    addressName = json['address_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_address_id'] = this.storeAddressId;
    data['address_name'] = this.addressName;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
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

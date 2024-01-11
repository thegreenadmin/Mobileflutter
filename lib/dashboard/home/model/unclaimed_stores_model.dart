class UnclaimedStoresModel {
  int? status;
  String? message;
  Data? data;

  UnclaimedStoresModel({this.status, this.message, this.data});

  UnclaimedStoresModel.fromJson(Map<String, dynamic> json) {
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
  List<UnclaimedStoreList>? storeAddresses;

  Data({this.totalCount, this.storeAddresses});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['store_addresses'] != null) {
      storeAddresses = <UnclaimedStoreList>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(new UnclaimedStoreList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.storeAddresses != null) {
      data['store_addresses'] =
          this.storeAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnclaimedStoreList {
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
  Store? store;

  UnclaimedStoreList(
      {this.storeAddressId,
      this.addressName,
      this.longitude,
      this.latitude,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.postalCode,
      this.state,
      this.store});

  UnclaimedStoreList.fromJson(Map<String, dynamic> json) {
    storeAddressId = json['store_address_id'];
    addressName = json['address_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    postalCode = json['postal_code'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
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
    data['postal_code'] = this.postalCode;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    return data;
  }
}

class State {
  String? id;
  String? countryId;
  String? stateName;
  String? status;
  String? createdAt;
  String? updatedAt;
  Country? country;

  State(
      {this.id,
      this.countryId,
      this.stateName,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.country});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    stateName = json['state_name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['state_name'] = this.stateName;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    return data;
  }
}

class Country {
  String? id;
  String? countryName;
  String? phoneCode;
  String? currency;
  String? abbrevation;
  String? status;
  String? createdAt;
  String? updatedAt;

  Country(
      {this.id,
      this.countryName,
      this.phoneCode,
      this.currency,
      this.abbrevation,
      this.status,
      this.createdAt,
      this.updatedAt});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    phoneCode = json['phone_code'];
    currency = json['currency'];
    abbrevation = json['abbrevation'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['phone_code'] = this.phoneCode;
    data['currency'] = this.currency;
    data['abbrevation'] = this.abbrevation;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Store {
  Logo? logo;
  Logo? image;
  bool? hasStoreOwner;
  String? storeId;
  String? storeName;
  bool? isVerified;
  bool? isEnabled;

  Store(
      {this.logo,
      this.image,
      this.hasStoreOwner,
      this.storeId,
      this.storeName,
      this.isVerified,
      this.isEnabled});

  Store.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    image = json['image'] != null ? new Logo.fromJson(json['image']) : null;
    hasStoreOwner = json['has_store_owner'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    isVerified = json['is_verified'];
    isEnabled = json['is_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['has_store_owner'] = this.hasStoreOwner;
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['is_verified'] = this.isVerified;
    data['is_enabled'] = this.isEnabled;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orignal_url'] = this.orignalUrl;
    data['dynamic_url'] = this.dynamicUrl;
    return data;
  }
}

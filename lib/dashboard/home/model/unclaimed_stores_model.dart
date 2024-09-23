class UnclaimedStoresModel {
  int? status;
  String? message;
  Data? data;

  UnclaimedStoresModel({this.status, this.message, this.data});

  UnclaimedStoresModel.fromJson(Map<String, dynamic> json) {
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
  List<UnclaimedStoreList>? storeAddresses;

  Data({this.totalCount, this.storeAddresses});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['store_addresses'] != null) {
      storeAddresses = <UnclaimedStoreList>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(UnclaimedStoreList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (storeAddresses != null) {
      data['store_addresses'] =
          storeAddresses!.map((v) => v.toJson()).toList();
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
    state = json['state'] != null ? State.fromJson(json['state']) : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
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
    data['postal_code'] = postalCode;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
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
        json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['state_name'] = stateName;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (country != null) {
      data['country'] = country!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_name'] = countryName;
    data['phone_code'] = phoneCode;
    data['currency'] = currency;
    data['abbrevation'] = abbrevation;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Store {
  Logo? logo;
  Logo? image;
  bool? hasStoreOwner;
  String? storeId;
  String? storeName;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  bool? isEnabled;

  Store(
      {this.logo,
      this.image,
      this.hasStoreOwner,
      this.storeId,
      this.storeName,
      this.storePhone,
      this.storePhoneCode,
      this.isVerified,
      this.isEnabled});

  Store.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    image = json['image'] != null ? Logo.fromJson(json['image']) : null;
    hasStoreOwner = json['has_store_owner'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    storePhone = json['store_phone'];
    storePhoneCode = json['store_phone_code'];
    isVerified = json['is_verified'];
    isEnabled = json['is_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (logo != null) {
      data['logo'] = logo!.toJson();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['has_store_owner'] = hasStoreOwner;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['store_phone'] = storePhone;
    data['store_phone_code'] = storePhoneCode;
    data['is_verified'] = isVerified;
    data['is_enabled'] = isEnabled;
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

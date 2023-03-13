class GetUserStoreListModel {
  int? status;
  String? message;
  Data? data;

  GetUserStoreListModel({this.status, this.message, this.data});

  GetUserStoreListModel.fromJson(Map<String, dynamic> json) {
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
  List<UserStoresList>? stores;

  Data({this.stores});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = <UserStoresList>[];
      json['stores'].forEach((v) {
        stores!.add(new UserStoresList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stores != null) {
      data['stores'] = this.stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserStoresList {
  String? storeId;
  String? storeName;
  String? storeEin;
  Images? image;
  List<Addresses>? addresses;

  UserStoresList(
      {this.storeId,
      this.storeName,
      this.storeEin,
      this.image,
      this.addresses});

  UserStoresList.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeEin = json['store_ein'];
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['store_ein'] = this.storeEin;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? orignalUrl;
  String? dynamicUrl;

  Images({this.orignalUrl, this.dynamicUrl});

  Images.fromJson(Map<String, dynamic> json) {
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

class Addresses {
  String? storeAddressId;
  String? addressName;
  double? longitude;
  double? latitude;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  States? state;

  Addresses(
      {this.storeAddressId,
      this.addressName,
      this.longitude,
      this.latitude,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.state});

  Addresses.fromJson(Map<String, dynamic> json) {
    storeAddressId = json['store_address_id'];
    addressName = json['address_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'] != null ? new States.fromJson(json['state']) : null;
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

class States {
  String? stateId;
  String? stateName;

  States({this.stateId, this.stateName});

  States.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    return data;
  }
}

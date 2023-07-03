import 'model.dart';

class GetUserStoreListModel {
  int? status;
  String? message;
  UserStoreListData? data;

  GetUserStoreListModel({this.status, this.message, this.data});

  GetUserStoreListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? UserStoreListData.fromJson(json['data']) : null;
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

class UserStoreListData {
  List<UserStoresList>? stores;

  UserStoreListData({this.stores});

  UserStoreListData.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = <UserStoresList>[];
      json['stores'].forEach((v) {
        stores!.add(UserStoresList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
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
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['store_ein'] = storeEin;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
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
    state = json['state'] != null ? States.fromJson(json['state']) : null;
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

class States {
  String? stateId;
  String? stateName;

  States({this.stateId, this.stateName});

  States.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    return data;
  }
}

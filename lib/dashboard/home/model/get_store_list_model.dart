import 'model.dart';

class GetStoreListModel {
  int? status;
  String? message;
  StoreListData? data;

  GetStoreListModel({this.status, this.message, this.data});

  GetStoreListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StoreListData.fromJson(json['data']) : null;
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

class StoreListData {
  List<Stores>? stores;

  StoreListData({this.stores});

  StoreListData.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(Stores.fromJson(v));
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

class Stores {
  String? storeId;
  Images? image;
  Images? logo;
  String? storeName;
  String? storeEin;
  // Business vertical: general / munchies / herbs
  String? storeType;
  // false when an admin has deactivated the store; owner/staff can view but
  // not operate it. Absent on older payloads → treat as active.
  bool? isEnabled;
  List<StoreAddresses>? storeAddresses;

  Stores(
      {this.storeId,
      this.image,
      this.logo,
      this.storeName,
      this.storeEin,
      this.storeType,
      this.isEnabled,
      this.storeAddresses});

  Stores.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
    logo = json['logo'] != null ? Images.fromJson(json['logo']) : null;
    storeName = json['store_name'];
    storeEin = json['store_ein'];
    storeType = json['store_type'];
    isEnabled = json['is_enabled'] ?? true;
    if (json['store_addresses'] != null) {
      storeAddresses = <StoreAddresses>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(StoreAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    if (logo != null) {
      data['logo'] = logo!.toJson();
    }
    data['store_name'] = storeName;
    data['store_ein'] = storeEin;
    data['store_type'] = storeType;
    data['is_enabled'] = isEnabled;
    if (storeAddresses != null) {
      data['store_addresses'] = storeAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*class Image {
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
}*/

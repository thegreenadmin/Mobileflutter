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
  List<StoreAddresses>? storeAddresses;

  Stores(
      {this.storeId,
      this.image,
      this.logo,
      this.storeName,
      this.storeEin,
      this.storeAddresses});

  Stores.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
    logo = json['logo'] != null ? new Images.fromJson(json['logo']) : null;
    storeName = json['store_name'];
    storeEin = json['store_ein'];
    if (json['store_addresses'] != null) {
      storeAddresses = <StoreAddresses>[];
      json['store_addresses'].forEach((v) {
        storeAddresses!.add(new StoreAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['store_name'] = this.storeName;
    data['store_ein'] = this.storeEin;
    if (this.storeAddresses != null) {
      data['store_addresses'] =
          this.storeAddresses!.map((v) => v.toJson()).toList();
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

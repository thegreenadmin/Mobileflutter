import 'offers_model.dart';

class GetUserOfferListModel {
  int? status;
  String? message;
  GetUserOfferData? data;

  GetUserOfferListModel({this.status, this.message, this.data});

  GetUserOfferListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? GetUserOfferData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class GetUserOfferData {
  int? totalCount;
  List<UserOfferStores>? stores;

  GetUserOfferData({this.totalCount, this.stores});

  GetUserOfferData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['stores'] != null) {
      stores = <UserOfferStores>[];
      json['stores'].forEach((v) {
        stores!.add(UserOfferStores.fromJson(v));
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

class UserOfferStores {
  Logo? logo;
  String? storeId;
  String? storeName;
  bool? isVerified;
  bool? isEnabled;
  List<StoreAddresses>? storeAddresses;
  List<Offer>? offers;

  UserOfferStores(
      {this.logo,
      this.storeId,
      this.storeName,
      this.isVerified,
      this.isEnabled,
      this.storeAddresses,
      this.offers});

  UserOfferStores.fromJson(Map<String, dynamic> json) {
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
      offers = <Offer>[];
      json['offers'].forEach((v) {
        offers!.add(Offer.fromJson(v));
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

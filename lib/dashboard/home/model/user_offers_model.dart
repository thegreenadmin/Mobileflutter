import 'model.dart';

class GetUserOfferModel {
  dynamic status;
  String? message;
  GetUserOfferData? data;

  GetUserOfferModel({this.status, this.message, this.data});

  GetUserOfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? GetUserOfferData.fromJson(json['data']) : null;
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

class GetUserOfferData {
  dynamic totalCount;
  List<UserOffers>? offers;

  GetUserOfferData({this.totalCount, this.offers});

  GetUserOfferData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['offers'] != null) {
      offers = <UserOffers>[];
      json['offers'].forEach((v) {
        offers!.add(UserOffers.fromJson(v));
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

class UserOffers {
  Images? image;
  String? offerId;
  String? storeId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  dynamic offerValue;
  bool? isExpired;
  String? expiredAt;
  String? status;
  String? createdAt;
  String? updatedAt;

  UserOffers(
      {this.image,
      this.offerId,
      this.storeId,
      this.isOfferForStore,
      this.offerName,
      this.offerType,
      this.offerValue,
      this.isExpired,
      this.expiredAt,
      this.status,
      this.createdAt,
      this.updatedAt});

  UserOffers.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
    offerId = json['offer_id'];
    storeId = json['store_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
    isExpired = json['is_expired'];
    expiredAt = json['expiredAt'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['offer_id'] = offerId;
    data['store_id'] = storeId;
    data['is_offer_for_store'] = isOfferForStore;
    data['offer_name'] = offerName;
    data['offer_type'] = offerType;
    data['offer_value'] = offerValue;
    data['is_expired'] = isExpired;
    data['expiredAt'] = expiredAt;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

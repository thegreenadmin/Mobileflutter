import 'package:thegreenmall/dashboard/home/model/user_offers_model.dart';

import 'offers_model.dart';

class GetOwnerOffersListModel {
  int? status;
  String? message;
  GetOwnerOffersData? data;

  GetOwnerOffersListModel({this.status, this.message, this.data});

  GetOwnerOffersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? GetOwnerOffersData.fromJson(json['data']) : null;
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

class GetOwnerOffersData {
  int? totalCount;
  List<OffersList>? offers;

  GetOwnerOffersData({this.totalCount, this.offers});

  GetOwnerOffersData.fromJson(Map<String, dynamic> json) {
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


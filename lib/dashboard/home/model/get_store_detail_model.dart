import 'model.dart';

class GetStoreDetailModel {
  int? status;
  String? message;
  StoreDetailData? data;

  GetStoreDetailModel({this.status, this.message, this.data});

  GetStoreDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StoreDetailData.fromJson(json['data']) : null;
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

class StoreDetailData {
  StoreRole? role;

  StoreDetailData({this.role});

  StoreDetailData.fromJson(Map<String, dynamic> json) {
    role = json['role'] != null ? StoreRole.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

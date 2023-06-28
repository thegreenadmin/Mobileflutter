import 'model.dart';

class GetParticularStoreModel {
  int? status;
  String? message;
  ParticularStoreData? data;

  GetParticularStoreModel({this.status, this.message, this.data});

  GetParticularStoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ParticularStoreData.fromJson(json['data'])
        : null;
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

class ParticularStoreData {
  Store? store;

  ParticularStoreData({this.store});

  ParticularStoreData.fromJson(Map<String, dynamic> json) {
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

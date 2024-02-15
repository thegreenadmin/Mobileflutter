import 'model.dart';

class OwnerFeaturedProductModel {
  int? status;
  String? message;
  OwnerFeaturedProductData? data;

  OwnerFeaturedProductModel({this.status, this.message, this.data});

  OwnerFeaturedProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? OwnerFeaturedProductData.fromJson(json['data'])
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

class OwnerFeaturedProductData {
  int? totalCount;
  List<ProductsList>? products;

  OwnerFeaturedProductData({this.totalCount, this.products});

  OwnerFeaturedProductData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['products'] != null) {
      products = <ProductsList>[];
      json['products'].forEach((v) {
        products!.add(ProductsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


// To parse this JSON data, do
//
//     final storeCategoriesListResponse = storeCategoriesListResponseFromJson(jsonString);

import 'dart:convert';

StoreCategoriesListResponse storeCategoriesListResponseFromJson(String str) => StoreCategoriesListResponse.fromJson(json.decode(str));

String storeCategoriesListResponseToJson(StoreCategoriesListResponse data) => json.encode(data.toJson());

class StoreCategoriesListResponse {
  StoreCategoriesListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  StoreCategoriesListResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      StoreCategoriesListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StoreCategoriesListResponse.fromJson(Map<String, dynamic> json) => StoreCategoriesListResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.categories,
  });

  List<Category>? categories;

  Data copyWith({
    List<Category>? categories,
  }) =>
      Data(
        categories: categories ?? this.categories,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.categoryId,
    this.parentCategoryId,
    this.isFeaturedCategory,
    this.categoryName,
    this.image,
    this.totalProducts,
  });

  String? categoryId;
  dynamic parentCategoryId;
  bool? isFeaturedCategory;
  String? categoryName;
  Image? image;
  int? totalProducts;

  Category copyWith({
    String? categoryId,
    dynamic parentCategoryId,
    bool? isFeaturedCategory,
    String? categoryName,
    Image? image,
    int? totalProducts,
  }) =>
      Category(
        categoryId: categoryId ?? this.categoryId,
        parentCategoryId: parentCategoryId ?? this.parentCategoryId,
        isFeaturedCategory: isFeaturedCategory ?? this.isFeaturedCategory,
        categoryName: categoryName ?? this.categoryName,
        image: image ?? this.image,
        totalProducts: totalProducts ?? this.totalProducts,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    parentCategoryId: json["parent_category_id"],
    isFeaturedCategory: json["is_featured_category"],
    categoryName: json["category_name"],
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    totalProducts: json["total_products"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "parent_category_id": parentCategoryId,
    "is_featured_category": isFeaturedCategory,
    "category_name": categoryName,
    "image": image?.toJson(),
    "total_products": totalProducts,
  };
}

class Image {
  Image({
    this.orignalUrl,
    this.dynamicUrl,
  });

  String? orignalUrl;
  String? dynamicUrl;

  Image copyWith({
    String? orignalUrl,
    String? dynamicUrl,
  }) =>
      Image(
        orignalUrl: orignalUrl ?? this.orignalUrl,
        dynamicUrl: dynamicUrl ?? this.dynamicUrl,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    orignalUrl: json["orignal_url"],
    dynamicUrl: json["dynamic_url"],
  );

  Map<String, dynamic> toJson() => {
    "orignal_url": orignalUrl,
    "dynamic_url": dynamicUrl,
  };
}

class GetCategoriesModel {
  int? status;
  String? message;
  Data? data;

  GetCategoriesModel({this.status, this.message, this.data});

  GetCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<Categories>? categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? categoryId;
  String? parentCategoryId;
  String? categoryName;
  Images? image;
  int? totalProducts;

  Categories(
      {this.categoryId,
      this.parentCategoryId,
      this.categoryName,
      this.image,
      this.totalProducts});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    parentCategoryId = json['parent_category_id'];
    categoryName = json['category_name'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
    totalProducts = json['total_products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['parent_category_id'] = parentCategoryId;
    data['category_name'] = categoryName;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['total_products'] = totalProducts;
    return data;
  }
}

class Images {
  String? orignalUrl;
  String? dynamicUrl;

  Images({this.orignalUrl, this.dynamicUrl});

  Images.fromJson(Map<String, dynamic> json) {
    orignalUrl = json['orignal_url'];
    dynamicUrl = json['dynamic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orignal_url'] = orignalUrl;
    data['dynamic_url'] = dynamicUrl;
    return data;
  }
}

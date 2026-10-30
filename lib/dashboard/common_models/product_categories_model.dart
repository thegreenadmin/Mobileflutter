import '../home/model/model.dart';

class ProductCategories {
  String? productCategoryId;
  String? categoryId;
  String? status;
  Category? category;

  ProductCategories(
      {productCategoryId, this.categoryId, this.status, this.category});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    productCategoryId = json['product_category_id']?.toString();
    categoryId = json['category_id']?.toString();
    status = json['status'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_category_id'] = productCategoryId;
    data['category_id'] = categoryId;
    data['status'] = status;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
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
  Images? image;
  int? totalProducts;

  Category copyWith({
    String? categoryId,
    dynamic parentCategoryId,
    bool? isFeaturedCategory,
    String? categoryName,
    Images? image,
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
        categoryId: json["category_id"]?.toString(),
        parentCategoryId: json["parent_category_id"],
        isFeaturedCategory: json["is_featured_category"],
        categoryName: json["category_name"],
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
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

class ProductContents {
  String? productContentId;
  String? heading;
  String? paragraph;
  int? order;
  String? status;

  ProductContents(
      {this.productContentId,
      this.heading,
      this.paragraph,
      this.order,
      this.status});

  ProductContents.fromJson(Map<String, dynamic> json) {
    productContentId = json['product_content_id'];
    heading = json['heading'];
    paragraph = json['paragraph'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_content_id'] = productContentId;
    data['heading'] = heading;
    data['paragraph'] = paragraph;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}

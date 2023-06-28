import 'model.dart';

class UserFeaturedProductModel {
  dynamic status;
  String? message;
  UserFeaturedProductData? data;

  UserFeaturedProductModel({this.status, this.message, this.data});

  UserFeaturedProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? UserFeaturedProductData.fromJson(json['data'])
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

class UserFeaturedProductData {
  dynamic totalCount;
  List<DataList>? products;

  UserFeaturedProductData({this.totalCount, this.products});

  UserFeaturedProductData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['products'] != null) {
      products = <DataList>[];
      json['products'].forEach((v) {
        products!.add(DataList.fromJson(v));
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

class DataList {
  String? productId;
  bool? isFavouriteProduct;
  String? storeId;
  dynamic quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  dynamic productPrice;
  dynamic sellingPrice;
  String? discountType;
  dynamic discountValue;
  bool? isProductReturnable;
  dynamic returnDaysCount;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic weight;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  QuantityType? quantityType;
  List<ProductCategories>? productCategories;
  List<ProductImages>? productImages;
  List<ProductContents>? productContents;
  dynamic offerPrice;
  Offer? offer;

  DataList(
      {this.productId,
      this.isFavouriteProduct,
      this.storeId,
      this.quantity,
      this.isFeaturedProduct,
      this.productName,
      this.description,
      this.productPrice,
      this.sellingPrice,
      this.discountType,
      this.discountValue,
      this.isProductReturnable,
      this.returnDaysCount,
      this.length,
      this.width,
      this.height,
      this.weight,
      this.isEnabled,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.quantityType,
      this.productCategories,
      this.productImages,
      this.productContents,
      this.offerPrice,
      this.offer});

  DataList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    isFavouriteProduct = json['is_favourite_product'];
    storeId = json['store_id'];
    quantity = json['quantity'];
    isFeaturedProduct = json['is_featured_product'];
    productName = json['product_name'];
    description = json['description'];
    productPrice = json['product_price'];
    sellingPrice = json['selling_price'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    isProductReturnable = json['is_product_returnable'];
    returnDaysCount = json['return_days_count'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    isEnabled = json['is_enabled'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    quantityType = json['quantity_type'] != null
        ? QuantityType.fromJson(json['quantity_type'])
        : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(ProductCategories.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContents>[];
      json['product_contents'].forEach((v) {
        productContents!.add(ProductContents.fromJson(v));
      });
    }
    offerPrice = json['offer_price'];
    offer = json['offer'] != null ? Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['is_favourite_product'] = isFavouriteProduct;
    data['store_id'] = storeId;
    data['quantity'] = quantity;
    data['is_featured_product'] = isFeaturedProduct;
    data['product_name'] = productName;
    data['description'] = description;
    data['product_price'] = productPrice;
    data['selling_price'] = sellingPrice;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['is_product_returnable'] = isProductReturnable;
    data['return_days_count'] = returnDaysCount;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['weight'] = weight;
    data['is_enabled'] = isEnabled;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (quantityType != null) {
      data['quantity_type'] = quantityType!.toJson();
    }
    if (productCategories != null) {
      data['product_categories'] =
          productCategories!.map((v) => v.toJson()).toList();
    }
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    if (productContents != null) {
      data['product_contents'] =
          productContents!.map((v) => v.toJson()).toList();
    }
    data['offer_price'] = offerPrice;
    if (offer != null) {
      data['offer'] = offer!.toJson();
    }
    return data;
  }
}

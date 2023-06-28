import 'model.dart';

class GetProductDetailModel {
  int? status;
  String? message;
  ProductDetailData? data;

  GetProductDetailModel({this.status, this.message, this.data});

  GetProductDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? ProductDetailData.fromJson(json['data']) : null;
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

class ProductDetailData {
  ProductDetail? product;

  ProductDetailData({this.product});

  ProductDetailData.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null
        ? ProductDetail.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class ProductDetail {
  String? productId;
  String? storeId;
  String? quantityTypeId;
  int? quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  int? productPrice;
  int? sellingPrice;
  String? discountType;
  int? discountValue;
  bool? isProductReturnable;
  int? returnDaysCount;
  int? length;
  int? width;
  int? height;
  int? weight;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  QuantityType? quantityType;
  List<ProductCategories>? productCategories;
  List<ProductDetailImages>? productImages;
  List<ProductContents>? productContents;
  List<ProductLinks>? productLinks;

  ProductDetail(
      {this.productId,
      this.storeId,
      this.quantityTypeId,
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
      this.productLinks});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    storeId = json['store_id'];
    quantityTypeId = json['quantity_type_id'];
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
      productImages = <ProductDetailImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductDetailImages.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContents>[];
      json['product_contents'].forEach((v) {
        productContents!.add(ProductContents.fromJson(v));
      });
    }
    if (json['product_links'] != null) {
      productLinks = <ProductLinks>[];
      json['product_links'].forEach((v) {
        productLinks!.add(ProductLinks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['store_id'] = storeId;
    data['quantity_type_id'] = quantityTypeId;
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
    if (productLinks != null) {
      data['product_links'] = productLinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetailImages {
  String? productImageId;
  String? imageUrl;
  int? order;
  String? status;

  ProductDetailImages(
      {this.productImageId, this.imageUrl, this.order, this.status});

  ProductDetailImages.fromJson(Map<String, dynamic> json) {
    productImageId = json['product_image_id'];
    imageUrl = json['image_url'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_id'] = productImageId;
    data['image_url'] = imageUrl;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}

class ProductLinks {
  String? productLinkId;
  String? name;
  String? link;
  int? order;
  String? status;

  ProductLinks(
      {this.productLinkId, this.name, this.link, this.order, this.status});

  ProductLinks.fromJson(Map<String, dynamic> json) {
    productLinkId = json['product_link_id'];
    name = json['name'];
    link = json['link'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_link_id'] = productLinkId;
    data['name'] = name;
    data['link'] = link;
    data['order'] = order;
    data['status'] = status;
    return data;
  }
}

import 'model.dart';

class InputAddProduct {
  List<ProductImagesList>? productImages;
  int? storeId;
  InputProduct? product;
  List<ProductCategories>? productCategories;
  List<ProductLink>? productLinks;
  List<ProductContent>? productContents;

  InputAddProduct(
      {this.productImages,
      this.storeId,
      this.product,
      this.productCategories,
      this.productLinks,
      this.productContents});

  InputAddProduct.fromJson(Map<String, dynamic> json) {
    if (json['product_images'] != null) {
      productImages = <ProductImagesList>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImagesList.fromJson(v));
      });
    }
    storeId = json['store_id'];
    product =
        json['product'] != null ? InputProduct.fromJson(json['product']) : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(ProductCategories.fromJson(v));
      });
    }
    if (json['product_links'] != null) {
      productLinks = <ProductLink>[];
      json['product_links'].forEach((v) {
        productLinks!.add(ProductLink.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContent>[];
      json['product_contents'].forEach((v) {
        productContents!.add(ProductContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    data['store_id'] = storeId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (productCategories != null) {
      data['product_categories'] =
          productCategories!.map((v) => v.toJson()).toList();
    }
    if (productLinks != null) {
      data['product_links'] = productLinks!.map((v) => v.toJson()).toList();
    }
    if (productContents != null) {
      data['product_contents'] =
          productContents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImagesList {
  String? imageUrl;
  String? dynamicImageUrl;
  String? productImageId;
  String? status;
  int? order;

  ProductImagesList(
      {this.imageUrl,
      this.productImageId,
      this.status,
      this.dynamicImageUrl,
      this.order});

  ProductImagesList.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    productImageId = json['product_image_id'];
    order = json['order'];
    status = json['status'];
    dynamicImageUrl = json['dynamic_url'];
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

class InputProduct {
  int? quantityTypeId;
  int? productId;
  dynamic quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  dynamic productPrice;
  dynamic sellingPrice;
  String? discountType;
  dynamic discountValue;
  bool? isProductReturnable;
  int? returnDaysCount;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic weight;
  bool? isEnabled;

  InputProduct(
      {this.quantityTypeId,
      this.productId,
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
      this.isEnabled});

  InputProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity_type_id'] = quantityTypeId;
    data['product_id'] = productId;
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
    return data;
  }
}

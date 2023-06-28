import 'offers_model.dart';

class GetOfferProductList {
  int? status;
  String? message;
  GetOfferProductData? data;

  GetOfferProductList({this.status, this.message, this.data});

  GetOfferProductList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new GetOfferProductData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetOfferProductData {
  int? totalCount;
  List<Products>? products;

  GetOfferProductData({this.totalCount, this.products});

  GetOfferProductData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productId;
  bool? isFavouriteProduct;
  bool? isPreviousProduct;
  String? storeId;
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
  List<ProductImages>? productImages;
  List<ProductContents>? productContents;
  double? offerPrice;
  Offer? offer;

  Products(
      {this.productId,
      this.isFavouriteProduct,
      this.isPreviousProduct,
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

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    isFavouriteProduct = json['is_favourite_product'];
    isPreviousProduct = json['is_previous_product'];
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
        ? new QuantityType.fromJson(json['quantity_type'])
        : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
    if (json['product_contents'] != null) {
      productContents = <ProductContents>[];
      json['product_contents'].forEach((v) {
        productContents!.add(new ProductContents.fromJson(v));
      });
    }
    offerPrice = json['offer_price'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['is_favourite_product'] = this.isFavouriteProduct;
    data['is_previous_product'] = this.isPreviousProduct;
    data['store_id'] = this.storeId;
    data['quantity'] = this.quantity;
    data['is_featured_product'] = this.isFeaturedProduct;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['product_price'] = this.productPrice;
    data['selling_price'] = this.sellingPrice;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['is_product_returnable'] = this.isProductReturnable;
    data['return_days_count'] = this.returnDaysCount;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['is_enabled'] = this.isEnabled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.quantityType != null) {
      data['quantity_type'] = this.quantityType!.toJson();
    }
    if (this.productCategories != null) {
      data['product_categories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.productContents != null) {
      data['product_contents'] =
          this.productContents!.map((v) => v.toJson()).toList();
    }
    data['offer_price'] = this.offerPrice;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    return data;
  }
}

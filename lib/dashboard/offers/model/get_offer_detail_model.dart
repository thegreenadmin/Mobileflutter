import 'offers_model.dart';

class GetOfferDetailModel {
  int? status;
  String? message;
  Data? data;

  GetOfferDetailModel({this.status, this.message, this.data});

  GetOfferDetailModel.fromJson(Map<String, dynamic> json) {
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
  Image? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  dynamic offerValue;
  bool? isExpired;
  String? expiredAt;
  String? createdAt;
  List<OfferProduct>? offerProducts;
  Store? store;

  Data(
      {this.image,
      this.offerId,
      this.isOfferForStore,
      this.offerName,
      this.offerType,
      this.offerValue,
      this.isExpired,
      this.expiredAt,
      this.createdAt,
      this.offerProducts,
      this.store});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    offerId = json['offer_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
    isExpired = json['is_expired'];
    expiredAt = json['expiredAt'];
    createdAt = json['createdAt'];
    if (json['offer_products'] != null) {
      offerProducts = <OfferProduct>[];
      json['offer_products'].forEach((v) {
        offerProducts!.add(OfferProduct.fromJson(v));
      });
    }
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['offer_id'] = offerId;
    data['is_offer_for_store'] = isOfferForStore;
    data['offer_name'] = offerName;
    data['offer_type'] = offerType;
    data['offer_value'] = offerValue;
    data['is_expired'] = isExpired;
    data['expiredAt'] = expiredAt;
    data['createdAt'] = createdAt;
    if (offerProducts != null) {
      data['offer_products'] = offerProducts!.map((v) => v.toJson()).toList();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

class Image {
  String? orignalUrl;
  String? dynamicUrl;

  Image({this.orignalUrl, this.dynamicUrl});

  Image.fromJson(Map<String, dynamic> json) {
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

class OfferProduct {
  String? offerProductId;
  String? productId;
  String? status;
  Product? product;

  OfferProduct(
      {this.offerProductId, this.productId, this.status, this.product});

  OfferProduct.fromJson(Map<String, dynamic> json) {
    offerProductId = json['offer_product_id'];
    productId = json['product_id'];
    status = json['status'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_product_id'] = offerProductId;
    data['product_id'] = productId;
    data['status'] = status;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? productId;
  Image? image;
  String? storeId;
  String? quantityTypeId;
  int? quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  dynamic productPrice;
  dynamic sellingPrice;
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

  Product(
      {this.productId,
      this.image,
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
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    if (image != null) {
      data['image'] = image!.toJson();
    }
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
    return data;
  }
}

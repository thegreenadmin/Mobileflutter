class GetOfferDetailModel {
  int? status;
  String? message;
  Data? data;

  GetOfferDetailModel({this.status, this.message, this.data});

  GetOfferDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
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
        offerProducts!.add(new OfferProduct.fromJson(v));
      });
    }
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['offer_id'] = this.offerId;
    data['is_offer_for_store'] = this.isOfferForStore;
    data['offer_name'] = this.offerName;
    data['offer_type'] = this.offerType;
    data['offer_value'] = this.offerValue;
    data['is_expired'] = this.isExpired;
    data['expiredAt'] = this.expiredAt;
    data['createdAt'] = this.createdAt;
    if (this.offerProducts != null) {
      data['offer_products'] =
          this.offerProducts!.map((v) => v.toJson()).toList();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orignal_url'] = this.orignalUrl;
    data['dynamic_url'] = this.dynamicUrl;
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
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_product_id'] = this.offerProductId;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
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
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['store_id'] = this.storeId;
    data['quantity_type_id'] = this.quantityTypeId;
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
    return data;
  }
}

class Store {
  String? storeId;
  String? storeName;

  Store({this.storeId, this.storeName});

  Store.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    storeName = json['store_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    return data;
  }
}

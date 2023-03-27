// To parse this JSON data, do
//
//     final cartListResponse = cartListResponseFromJson(jsonString);

import 'dart:convert';

CartListResponse cartListResponseFromJson(String str) => CartListResponse.fromJson(json.decode(str));

String cartListResponseToJson(CartListResponse data) => json.encode(data.toJson());

class CartListResponse {
  CartListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  CartListResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      CartListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CartListResponse.fromJson(Map<String, dynamic> json) => CartListResponse(
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
    this.cartTotalPrice,
    this.cartItems,
  });

  double? cartTotalPrice;
  List<CartItem>? cartItems;

  Data copyWith({
    double? cartTotalPrice,
    List<CartItem>? cartItems,
  }) =>
      Data(
        cartTotalPrice: cartTotalPrice ?? this.cartTotalPrice,
        cartItems: cartItems ?? this.cartItems,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cartTotalPrice: json["cart_total_price"]?.toDouble(),
    cartItems: json["cart_items"] == null ? [] : List<CartItem>.from(json["cart_items"]!.map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_total_price": cartTotalPrice,
    "cart_items": cartItems == null ? [] : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
  };
}

class CartItem {
  CartItem({
    this.cartItemId,
    this.quantity,
    this.offerPrice,
    this.totalPrice,
    this.offer,
    this.product,
  });

  String? cartItemId;
  int? quantity;
  double? offerPrice;
  double? totalPrice;
  Offer? offer;
  Product? product;

  CartItem copyWith({
    String? cartItemId,
    int? quantity,
    double? offerPrice,
    double? totalPrice,
    Offer? offer,
    Product? product,
  }) =>
      CartItem(
        cartItemId: cartItemId ?? this.cartItemId,
        quantity: quantity ?? this.quantity,
        offerPrice: offerPrice ?? this.offerPrice,
        totalPrice: totalPrice ?? this.totalPrice,
        offer: offer ?? this.offer,
        product: product ?? this.product,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    cartItemId: json["cart_item_id"],
    quantity: json["quantity"],
    offerPrice: json["offer_price"]?.toDouble(),
    totalPrice: json["total_price"]?.toDouble(),
    offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "cart_item_id": cartItemId,
    "quantity": quantity,
    "offer_price": offerPrice,
    "total_price": totalPrice,
    "offer": offer?.toJson(),
    "product": product?.toJson(),
  };
}

class Offer {
  Offer({
    this.image,
    this.offerId,
    this.isOfferForStore,
    this.offerName,
    this.offerType,
    this.offerValue,
    this.isExpired,
    this.createdAt,
    this.status,
  });

  Image? image;
  String? offerId;
  bool? isOfferForStore;
  String? offerName;
  String? offerType;
  int? offerValue;
  bool? isExpired;
  DateTime? createdAt;
  String? status;

  Offer copyWith({
    Image? image,
    String? offerId,
    bool? isOfferForStore,
    String? offerName,
    String? offerType,
    int? offerValue,
    bool? isExpired,
    DateTime? createdAt,
    String? status,
  }) =>
      Offer(
        image: image ?? this.image,
        offerId: offerId ?? this.offerId,
        isOfferForStore: isOfferForStore ?? this.isOfferForStore,
        offerName: offerName ?? this.offerName,
        offerType: offerType ?? this.offerType,
        offerValue: offerValue ?? this.offerValue,
        isExpired: isExpired ?? this.isExpired,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
      );

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    offerId: json["offer_id"],
    isOfferForStore: json["is_offer_for_store"],
    offerName: json["offer_name"],
    offerType: json["offer_type"],
    offerValue: json["offer_value"],
    isExpired: json["is_expired"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "image": image?.toJson(),
    "offer_id": offerId,
    "is_offer_for_store": isOfferForStore,
    "offer_name": offerName,
    "offer_type": offerType,
    "offer_value": offerValue,
    "is_expired": isExpired,
    "createdAt": createdAt?.toIso8601String(),
    "status": status,
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

class Product {
  Product({
    this.productId,
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
    this.updatedAt,
  });

  String? productId;
  Image? image;
  String? storeId;
  String? quantityTypeId;
  int? quantity;
  bool? isFeaturedProduct;
  String? productName;
  String? description;
  double? productPrice;
  double? sellingPrice;
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
  DateTime? createdAt;
  DateTime? updatedAt;

  Product copyWith({
    String? productId,
    Image? image,
    String? storeId,
    String? quantityTypeId,
    int? quantity,
    bool? isFeaturedProduct,
    String? productName,
    String? description,
    double? productPrice,
    double? sellingPrice,
    String? discountType,
    int? discountValue,
    bool? isProductReturnable,
    int? returnDaysCount,
    int? length,
    int? width,
    int? height,
    int? weight,
    bool? isEnabled,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Product(
        productId: productId ?? this.productId,
        image: image ?? this.image,
        storeId: storeId ?? this.storeId,
        quantityTypeId: quantityTypeId ?? this.quantityTypeId,
        quantity: quantity ?? this.quantity,
        isFeaturedProduct: isFeaturedProduct ?? this.isFeaturedProduct,
        productName: productName ?? this.productName,
        description: description ?? this.description,
        productPrice: productPrice ?? this.productPrice,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        isProductReturnable: isProductReturnable ?? this.isProductReturnable,
        returnDaysCount: returnDaysCount ?? this.returnDaysCount,
        length: length ?? this.length,
        width: width ?? this.width,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    storeId: json["store_id"],
    quantityTypeId: json["quantity_type_id"],
    quantity: json["quantity"],
    isFeaturedProduct: json["is_featured_product"],
    productName: json["product_name"],
    description: json["description"],
    productPrice: json["product_price"]?.toDouble(),
    sellingPrice: json["selling_price"]?.toDouble(),
    discountType: json["discount_type"],
    discountValue: json["discount_value"],
    isProductReturnable: json["is_product_returnable"],
    returnDaysCount: json["return_days_count"],
    length: json["length"],
    width: json["width"],
    height: json["height"],
    weight: json["weight"],
    isEnabled: json["is_enabled"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "image": image?.toJson(),
    "store_id": storeId,
    "quantity_type_id": quantityTypeId,
    "quantity": quantity,
    "is_featured_product": isFeaturedProduct,
    "product_name": productName,
    "description": description,
    "product_price": productPrice,
    "selling_price": sellingPrice,
    "discount_type": discountType,
    "discount_value": discountValue,
    "is_product_returnable": isProductReturnable,
    "return_days_count": returnDaysCount,
    "length": length,
    "width": width,
    "height": height,
    "weight": weight,
    "is_enabled": isEnabled,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

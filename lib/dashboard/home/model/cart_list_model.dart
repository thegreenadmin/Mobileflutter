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

  dynamic status;
  String? message;
  Data? data;

  CartListResponse copyWith({
    dynamic status,
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
    this.cartSubTotal,
    this.cartTotalDiscount,
    this.cartTotalTax,
    this.cartDeliveryServiceCharge,
    this.storeId,
    this.cartTotalServiceCharged,
    this.isValidAddress,
    this.isOrderDeliverable,
    this.cartItems,
  });

  dynamic cartTotalPrice;
  dynamic cartSubTotal;
  double? cartTotalDiscount;
  double? cartTotalTax;
  dynamic cartDeliveryServiceCharge;
  String? storeId;
  dynamic cartTotalServiceCharged;
  bool? isValidAddress;
  bool? isOrderDeliverable;
  List<CartItem>? cartItems;

  Data copyWith({
    double? cartTotalPrice,
    dynamic cartSubTotal,
    double? cartTotalDiscount,
    double? cartTotalTax,
    dynamic cartDeliveryServiceCharge,
    String? storeId,
    dynamic cartTotalServiceCharged,
    bool? isValidAddress,
    bool? isOrderDeliverable,
    List<CartItem>? cartItems,
  }) =>
      Data(
        storeId: storeId ?? this.storeId,
        cartTotalPrice: cartTotalPrice ?? this.cartTotalPrice,
        cartSubTotal: cartSubTotal ?? this.cartSubTotal,
        cartTotalDiscount: cartTotalDiscount ?? this.cartTotalDiscount,
        cartTotalServiceCharged: cartTotalServiceCharged ?? this.cartTotalServiceCharged,
        cartTotalTax: cartTotalTax ?? this.cartTotalTax,
        cartDeliveryServiceCharge: cartDeliveryServiceCharge ?? this.cartDeliveryServiceCharge,
        isValidAddress: isValidAddress ?? this.isValidAddress,
        isOrderDeliverable: isOrderDeliverable ?? this.isOrderDeliverable,
        cartItems: cartItems ?? this.cartItems,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    storeId: json["store_id"],
    cartTotalPrice: json["cart_total_price"]?.toDouble(),
    cartSubTotal: json["cart_sub_total"],
    cartTotalDiscount: json["cart_total_discount"]?.toDouble(),
    cartTotalServiceCharged: json["cart_total_service_charged"]?.toDouble(),
    cartTotalTax: json["cart_total_tax"]?.toDouble(),
    cartDeliveryServiceCharge: json["cart_delivery_service_charge"],
    isValidAddress: json["is_valid_address"],
    isOrderDeliverable: json["is_order_deliverable"],
    cartItems: json["cart_items"] == null ? [] : List<CartItem>.from(json["cart_items"]!.map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "store_id": storeId,
    "cart_total_price": cartTotalPrice,
    "cart_sub_total": cartSubTotal,
    "cart_total_discount": cartTotalDiscount,
    "cart_total_service_charged": cartTotalServiceCharged,
    "cart_total_tax": cartTotalTax,
    "cart_delivery_service_charge": cartDeliveryServiceCharge,
    "is_valid_address": isValidAddress,
    "is_order_deliverable": isOrderDeliverable,
    "cart_items": cartItems == null ? [] : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
  };
}

class CartItem {
  CartItem({
    this.cartItemId,
    this.itemsCount,
    this.offerPrice,
    this.totalPrice,
    this.totalDiscount,
    this.offer,
    this.product,
  });

  String? cartItemId;
  dynamic itemsCount;
  double? offerPrice;
  double? totalPrice;
  double? totalDiscount;
  dynamic offer;
  Product? product;

  CartItem copyWith({
    String? cartItemId,
    dynamic itemsCount,
    double? offerPrice,
    double? totalPrice,
    double? totalDiscount,
    dynamic offer,
    Product? product,
  }) =>
      CartItem(
        cartItemId: cartItemId ?? this.cartItemId,
        itemsCount: itemsCount ?? this.itemsCount,
        offerPrice: offerPrice ?? this.offerPrice,
        totalPrice: totalPrice ?? this.totalPrice,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        offer: offer ?? this.offer,
        product: product ?? this.product,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    cartItemId: json["cart_item_id"],
    itemsCount: json["items_count"],
    offerPrice: json["offer_price"]?.toDouble(),
    totalPrice: json["total_price"]?.toDouble(),
    totalDiscount: json["total_discount"]?.toDouble(),
    offer: json["offer"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "cart_item_id": cartItemId,
    "items_count": itemsCount,
    "offer_price": offerPrice,
    "total_price": totalPrice,
    "total_discount": totalDiscount,
    "offer": offer,
    "product": product?.toJson(),
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
  DateTime? createdAt;
  DateTime? updatedAt;

  Product copyWith({
    String? productId,
    Image? image,
    String? storeId,
    String? quantityTypeId,
    dynamic quantity,
    bool? isFeaturedProduct,
    String? productName,
    String? description,
    dynamic productPrice,
    dynamic sellingPrice,
    String? discountType,
    dynamic discountValue,
    bool? isProductReturnable,
    dynamic returnDaysCount,
    dynamic length,
    dynamic width,
    dynamic height,
    dynamic weight,
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
    productPrice: json["product_price"],
    sellingPrice: json["selling_price"],
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

class Image {
  Image({
    this.orignalUrl,
    this.dynamicUrl,
  });

  dynamic orignalUrl;
  dynamic dynamicUrl;

  Image copyWith({
    dynamic orignalUrl,
    dynamic dynamicUrl,
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

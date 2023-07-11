import 'model.dart';

class ActiveCartModel {
  dynamic status;
  String? message;
  ActiveCartData? data;

  ActiveCartModel({this.status, this.message, this.data});

  ActiveCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ActiveCartData.fromJson(json['data']) : null;
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

class ActiveCartData {
  String? storeId;
  dynamic cartTotalPrice;
  dynamic cartSubTotal;
  dynamic cartTotalDiscount;
  dynamic cartTotalServiceCharged;
  dynamic cartTotalTax;
  dynamic cartDeliveryServiceCharge;
  bool? isValidAddress;
  bool? isOrderDeliverable;
  List<CartItems>? cartItems;

  ActiveCartData(
      {this.storeId,
      this.cartTotalPrice,
      this.cartSubTotal,
      this.cartTotalDiscount,
      this.cartTotalServiceCharged,
      this.cartTotalTax,
      this.cartDeliveryServiceCharge,
      this.isValidAddress,
      this.isOrderDeliverable,
      this.cartItems});

  ActiveCartData.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    cartTotalPrice = json['cart_total_price'];
    cartSubTotal = json['cart_sub_total'];
    cartTotalDiscount = json['cart_total_discount'];
    cartTotalServiceCharged = json['cart_total_service_charged'];
    cartTotalTax = json['cart_total_tax'];
    cartDeliveryServiceCharge = json['cart_delivery_service_charge'];
    isValidAddress = json['is_valid_address'];
    isOrderDeliverable = json['is_order_deliverable'];
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['cart_total_price'] = cartTotalPrice;
    data['cart_sub_total'] = cartSubTotal;
    data['cart_total_discount'] = cartTotalDiscount;
    data['cart_total_service_charged'] = cartTotalServiceCharged;
    data['cart_total_tax'] = cartTotalTax;
    data['cart_delivery_service_charge'] = cartDeliveryServiceCharge;
    data['is_valid_address'] = isValidAddress;
    data['is_order_deliverable'] = isOrderDeliverable;
    if (cartItems != null) {
      data['cart_items'] = cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItems {
  String? cartItemId;
  dynamic itemsCount;
  String? serviceChargeType;
  dynamic serviceChargeValue;
  dynamic totalServiceCharged;
  dynamic offerPrice;
  dynamic totalDiscount;
  dynamic totalTaxAmount;
  dynamic totalPrice;

  Product? product;

  CartItems(
      {this.cartItemId,
      this.itemsCount,
      this.serviceChargeType,
      this.serviceChargeValue,
      this.totalServiceCharged,
      this.offerPrice,
      this.totalDiscount,
      this.totalTaxAmount,
      this.totalPrice,
      this.product});

  CartItems.fromJson(Map<String, dynamic> json) {
    cartItemId = json['cart_item_id'];
    itemsCount = json['items_count'];
    serviceChargeType = json['service_charge_type'];
    serviceChargeValue = json['service_charge_value'];
    totalServiceCharged = json['total_service_charged'];
    offerPrice = json['offer_price'];
    totalDiscount = json['total_discount'];
    totalTaxAmount = json['total_tax_amount'];
    totalPrice = json['total_price'];

    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_item_id'] = cartItemId;
    data['items_count'] = itemsCount;
    data['service_charge_type'] = serviceChargeType;
    data['service_charge_value'] = serviceChargeValue;
    data['total_service_charged'] = totalServiceCharged;
    data['offer_price'] = offerPrice;
    data['total_discount'] = totalDiscount;
    data['total_tax_amount'] = totalTaxAmount;
    data['total_price'] = totalPrice;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

/*class Product {
  String? productId;
  Images? image;
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
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
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
}*/

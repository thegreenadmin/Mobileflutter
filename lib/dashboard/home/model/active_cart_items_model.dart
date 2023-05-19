class ActiveCartModel {
  int? status;
  String? message;
  Data? data;

  ActiveCartModel({this.status, this.message, this.data});

  ActiveCartModel.fromJson(Map<String, dynamic> json) {
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
  String? storeId;
  double? cartTotalPrice;
  int? cartSubTotal;
  double? cartTotalDiscount;
  double? cartTotalServiceCharged;
  double? cartTotalTax;
  int? cartDeliveryServiceCharge;
  bool? isValidAddress;
  bool? isOrderDeliverable;
  List<CartItems>? cartItems;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['cart_total_price'] = this.cartTotalPrice;
    data['cart_sub_total'] = this.cartSubTotal;
    data['cart_total_discount'] = this.cartTotalDiscount;
    data['cart_total_service_charged'] = this.cartTotalServiceCharged;
    data['cart_total_tax'] = this.cartTotalTax;
    data['cart_delivery_service_charge'] = this.cartDeliveryServiceCharge;
    data['is_valid_address'] = this.isValidAddress;
    data['is_order_deliverable'] = this.isOrderDeliverable;
    if (this.cartItems != null) {
      data['cart_items'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItems {
  String? cartItemId;
  int? itemsCount;
  String? serviceChargeType;
  double? serviceChargeValue;
  double? totalServiceCharged;
  double? offerPrice;
  double? totalDiscount;
  double? totalTaxAmount;
  double? totalPrice;
  Null? offer;
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
      this.offer,
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
    offer = json['offer'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_item_id'] = this.cartItemId;
    data['items_count'] = this.itemsCount;
    data['service_charge_type'] = this.serviceChargeType;
    data['service_charge_value'] = this.serviceChargeValue;
    data['total_service_charged'] = this.totalServiceCharged;
    data['offer_price'] = this.offerPrice;
    data['total_discount'] = this.totalDiscount;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['total_price'] = this.totalPrice;
    data['offer'] = this.offer;
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

class Image {
  Null? orignalUrl;
  Null? dynamicUrl;

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

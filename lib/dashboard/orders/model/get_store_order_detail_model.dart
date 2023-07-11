import 'orders_model.dart';

class GetStoreOrderDetailModel {
  dynamic status;
  String? message;
  StoreOrderDetailData? data;

  GetStoreOrderDetailModel({this.status, this.message, this.data});

  GetStoreOrderDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? StoreOrderDetailData.fromJson(json['data'])
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

class StoreOrderDetailData {
  Order? order;
  UserProof? userProof;
  StoreOrderDetailData({this.order, this.userProof});

  StoreOrderDetailData.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    userProof = json['user_proof'] != null
        ? UserProof.fromJson(json['user_proof'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (userProof != null) {
      data['user_proof'] = userProof!.toJson();
    }
    return data;
  }
}

class OrderHistories {
  String? orderHistoryId;
  String? orderStatusId;
  bool? isCurrentStatus;
  String? createdAt;
  String? updatedAt;
  OrderStatus? orderStatus;
  bool? isCreatedByStore;

  OrderHistories(
      {this.orderHistoryId,
      this.orderStatusId,
      this.isCurrentStatus,
      this.isCreatedByStore,
      this.createdAt,
      this.updatedAt,
      this.orderStatus});

  OrderHistories.fromJson(Map<String, dynamic> json) {
    orderHistoryId = json['order_history_id'];
    orderStatusId = json['order_status_id'];
    isCreatedByStore = json['is_created_by_store'];
    isCurrentStatus = json['is_current_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderStatus = json['order_status'] != null
        ? OrderStatus.fromJson(json['order_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_history_id'] = orderHistoryId;
    data['order_status_id'] = orderStatusId;
    data['is_created_by_store'] = isCreatedByStore;
    data['is_current_status'] = isCurrentStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (orderStatus != null) {
      data['order_status'] = orderStatus!.toJson();
    }
    return data;
  }
}

class OrderDeliveryAddresses {
  String? orderId;
  String? stateId;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  String? orderDeliveryAddressId;
  State? state;

  OrderDeliveryAddresses(
      {this.orderId,
      this.stateId,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.postalCode,
      this.orderDeliveryAddressId,
      this.state});

  OrderDeliveryAddresses.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    stateId = json['state_id'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    postalCode = json['postal_code'];
    orderDeliveryAddressId = json['order_delivery_address_id'];
    state = json['state'] != null ? State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['state_id'] = stateId;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['landmark'] = landmark;
    data['city'] = city;
    data['postal_code'] = postalCode;
    data['order_delivery_address_id'] = orderDeliveryAddressId;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}

class Product {
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
  String? productId;
  List<ProductReviews>? productReviews;
  List<ProductImages>? productImages;
  Images? image;

  Product(
      {this.storeId,
      this.image,
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
      this.productId,
      this.productReviews,
      this.productImages});

  Product.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
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
    productId = json['product_id'];
    if (json['product_reviews'] != null) {
      productReviews = <ProductReviews>[];
      json['product_reviews'].forEach((v) {
        productReviews!.add(ProductReviews.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    if (image != null) {
      data['image'] = image!.toJson();
    }
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
    data['product_id'] = productId;
    if (productReviews != null) {
      data['product_reviews'] = productReviews!.map((v) => v.toJson()).toList();
    }
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductReviews {
  String? productId;
  String? userId;
  String? orderId;
  dynamic rating;
  String? review;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? productReviewId;

  ProductReviews(
      {this.productId,
      this.userId,
      this.orderId,
      this.rating,
      this.review,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.productReviewId});

  ProductReviews.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    rating = json['rating'];
    review = json['review'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productReviewId = json['product_review_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['rating'] = rating;
    data['review'] = review;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['product_review_id'] = productReviewId;
    return data;
  }
}

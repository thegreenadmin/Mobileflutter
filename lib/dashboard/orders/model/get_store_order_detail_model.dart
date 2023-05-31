class GetStoreOrderDetailModel {
  dynamic status;
  String? message;
  Data? data;

  GetStoreOrderDetailModel({this.status, this.message, this.data});

  GetStoreOrderDetailModel.fromJson(Map<String, dynamic> json) {
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
  Order? order;

  Data({this.order});

  Data.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? userId;
  String? storeId;
  String? deliveryServiceId;
  dynamic deliveryCharge;
  String? taxType;
  dynamic taxValue;
  dynamic totalTaxCharged;
  dynamic totalAmount;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? customerPhoneCode;
  String? estimateDeliveryDate;
  String? orderDate;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderId;
  DeliveryService? deliveryService;
  List<OrderHistories>? orderHistories;
  List<OrderDeliveryAddresses>? orderDeliveryAddresses;
  List<OrderItems>? orderItems;

  Order(
      {this.userId,
      this.storeId,
      this.deliveryServiceId,
      this.deliveryCharge,
      this.taxType,
      this.taxValue,
      this.totalTaxCharged,
      this.totalAmount,
      this.customerName,
      this.customerEmail,
      this.customerPhone,
      this.customerPhoneCode,
      this.estimateDeliveryDate,
      this.orderDate,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.orderId,
      this.deliveryService,
      this.orderHistories,
      this.orderDeliveryAddresses,
      this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    storeId = json['store_id'];
    deliveryServiceId = json['delivery_service_id'];
    deliveryCharge = json['delivery_charge'];
    taxType = json['tax_type'];
    taxValue = json['tax_value'];
    totalTaxCharged = json['total_tax_charged'];
    totalAmount = json['total_amount'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
    customerPhoneCode = json['customer_phone_code'];
    estimateDeliveryDate = json['estimate_delivery_date'];
    orderDate = json['order_date'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderId = json['order_id'];
    deliveryService = json['delivery_service'] != null
        ? DeliveryService.fromJson(json['delivery_service'])
        : null;
    if (json['order_histories'] != null) {
      orderHistories = <OrderHistories>[];
      json['order_histories'].forEach((v) {
        orderHistories!.add(OrderHistories.fromJson(v));
      });
    }
    if (json['order_delivery_addresses'] != null) {
      orderDeliveryAddresses = <OrderDeliveryAddresses>[];
      json['order_delivery_addresses'].forEach((v) {
        orderDeliveryAddresses!.add(OrderDeliveryAddresses.fromJson(v));
      });
    }
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['delivery_service_id'] = deliveryServiceId;
    data['delivery_charge'] = deliveryCharge;
    data['tax_type'] = taxType;
    data['tax_value'] = taxValue;
    data['total_tax_charged'] = totalTaxCharged;
    data['total_amount'] = totalAmount;
    data['customer_name'] = customerName;
    data['customer_email'] = customerEmail;
    data['customer_phone'] = customerPhone;
    data['customer_phone_code'] = customerPhoneCode;
    data['estimate_delivery_date'] = estimateDeliveryDate;
    data['order_date'] = orderDate;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['order_id'] = orderId;
    if (deliveryService != null) {
      data['delivery_service'] = deliveryService!.toJson();
    }
    if (orderHistories != null) {
      data['order_histories'] = orderHistories!.map((v) => v.toJson()).toList();
    }
    if (orderDeliveryAddresses != null) {
      data['order_delivery_addresses'] =
          orderDeliveryAddresses!.map((v) => v.toJson()).toList();
    }
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryService {
  String? deliveryServiceName;
  String? deliveryServiceId;

  DeliveryService({this.deliveryServiceName, this.deliveryServiceId});

  DeliveryService.fromJson(Map<String, dynamic> json) {
    deliveryServiceName = json['delivery_service_name'];
    deliveryServiceId = json['delivery_service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivery_service_name'] = deliveryServiceName;
    data['delivery_service_id'] = deliveryServiceId;
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

  OrderHistories(
      {this.orderHistoryId,
      this.orderStatusId,
      this.isCurrentStatus,
      this.createdAt,
      this.updatedAt,
      this.orderStatus});

  OrderHistories.fromJson(Map<String, dynamic> json) {
    orderHistoryId = json['order_history_id'];
    orderStatusId = json['order_status_id'];
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
    data['is_current_status'] = isCurrentStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (orderStatus != null) {
      data['order_status'] = orderStatus!.toJson();
    }
    return data;
  }
}

class OrderStatus {
  String? orderStatusId;
  String? orderStatusName;

  OrderStatus({this.orderStatusId, this.orderStatusName});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    orderStatusId = json['order_status_id'];
    orderStatusName = json['order_status_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_status_id'] = orderStatusId;
    data['order_status_name'] = orderStatusName;
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

class State {
  String? stateId;
  String? stateName;
  Country? country;

  State({this.stateId, this.stateName, this.country});

  State.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}

class Country {
  String? countryId;
  String? countryName;

  Country({this.countryId, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    return data;
  }
}

class OrderItems {
  String? orderId;
  String? productId;
  dynamic orderItemCount;
  dynamic orderItemPrice;
  String? serviceChargeType;
  dynamic serviceChargeValue;
  dynamic totalServiceCharged;
  String? discountName;
  String? discountType;
  dynamic discountValue;
  dynamic totalDiscount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderItemId;
  Product? product;
  bool? isSelected;
  List<ReturnOrderItem>? returnOrderItems;
  String? orderItemStatus;
  dynamic cancelledAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic returedAt;

  OrderItems({
    this.orderId,
    this.productId,
    this.orderItemCount,
    this.orderItemPrice,
    this.serviceChargeType,
    this.serviceChargeValue,
    this.totalServiceCharged,
    this.discountName,
    this.discountType,
    this.discountValue,
    this.totalDiscount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderItemId,
    this.product,
    this.isSelected,
    this.returnOrderItems,
    this.orderItemStatus,
    this.cancelledAt,
    this.shippedAt,
    this.deliveredAt,
    this.returedAt,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    orderItemCount = json['order_item_count'];
    orderItemPrice = json['order_item_price'];
    serviceChargeType = json['service_charge_type'];
    serviceChargeValue = json['service_charge_value'];
    totalServiceCharged = json['total_service_charged'];
    discountName = json['discount_name'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    totalDiscount = json['total_discount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderItemId = json['order_item_id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    returnOrderItems = json["return_order_items"] == null
        ? []
        : List<ReturnOrderItem>.from(json["return_order_items"]!
            .map((x) => ReturnOrderItem.fromJson(x)));
    orderItemStatus = json["order_item_status"];
    cancelledAt = json["cancelledAt"];
    shippedAt = json["shippedAt"];
    deliveredAt = json["deliveredAt"];
    returedAt = json["returedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['order_item_count'] = orderItemCount;
    data['order_item_price'] = orderItemPrice;
    data['service_charge_type'] = serviceChargeType;
    data['service_charge_value'] = serviceChargeValue;
    data['total_service_charged'] = totalServiceCharged;
    data['discount_name'] = discountName;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['total_discount'] = totalDiscount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['order_item_id'] = orderItemId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (returnOrderItems != null) {
      data['return_order_items'] =
          List<dynamic>.from(returnOrderItems!.map((x) => x.toJson()));
    }
    data['return_order_items'] = returnOrderItems;
    data['order_item_status'] = orderItemStatus;
    data['cancelledAt'] = cancelledAt;
    data['shippedAt'] = shippedAt;
    data['deliveredAt'] = deliveredAt;
    data['returedAt'] = returedAt;
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

  Product(
      {this.storeId,
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class ReturnOrderItem {
  ReturnOrderItem({
    this.orderItemId,
    this.returnItemsCount,
    this.remarks,
    this.totalTaxReversed,
    this.totalAmountReversed,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.returnOrderItemId,
  });

  String? orderItemId;
  int? returnItemsCount;
  String? remarks;
  double? totalTaxReversed;
  double? totalAmountReversed;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? returnOrderItemId;

  ReturnOrderItem copyWith({
    String? orderItemId,
    int? returnItemsCount,
    String? remarks,
    double? totalTaxReversed,
    double? totalAmountReversed,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? returnOrderItemId,
  }) =>
      ReturnOrderItem(
        orderItemId: orderItemId ?? this.orderItemId,
        returnItemsCount: returnItemsCount ?? this.returnItemsCount,
        remarks: remarks ?? this.remarks,
        totalTaxReversed: totalTaxReversed ?? this.totalTaxReversed,
        totalAmountReversed: totalAmountReversed ?? this.totalAmountReversed,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        returnOrderItemId: returnOrderItemId ?? this.returnOrderItemId,
      );

  factory ReturnOrderItem.fromJson(Map<String, dynamic> json) =>
      ReturnOrderItem(
        orderItemId: json["order_item_id"],
        returnItemsCount: json["return_items_count"],
        remarks: json["remarks"],
        totalTaxReversed: json["total_tax_reversed"]?.toDouble(),
        totalAmountReversed: json["total_amount_reversed"]?.toDouble(),
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        returnOrderItemId: json["return_order_item_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_item_id": orderItemId,
        "return_items_count": returnItemsCount,
        "remarks": remarks,
        "total_tax_reversed": totalTaxReversed,
        "total_amount_reversed": totalAmountReversed,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "return_order_item_id": returnOrderItemId,
      };
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

class ProductImages {
  Image? image;

  ProductImages({this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.toJson();
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

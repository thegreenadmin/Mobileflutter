class GetOwnerOrderHistoryModel {
  dynamic status;
  String? message;
  Data? data;

  GetOwnerOrderHistoryModel({this.status, this.message, this.data});

  GetOwnerOrderHistoryModel.fromJson(Map<String, dynamic> json) {
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
  dynamic totalCount;
  List<Orders>? orders;
  dynamic userProof;
  Data({
    this.totalCount,
    this.orders,
    this.userProof,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    userProof = json["user_proof"];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    data['user_proof'] = userProof;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
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
  Store? store;
  DeliveryService? deliveryService;
  List<OrderHistories>? orderHistories;
  List<OrderItems>? orderItems;
  List<OrderDeliveryAddresses>? orderDeliveryAddresses;

  Orders(
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
      this.store,
      this.deliveryService,
      this.orderHistories,
      this.orderItems,
      this.orderDeliveryAddresses});

  Orders.fromJson(Map<String, dynamic> json) {
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
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    deliveryService = json['delivery_service'] != null
        ? DeliveryService.fromJson(json['delivery_service'])
        : null;
    if (json['order_histories'] != null) {
      orderHistories = <OrderHistories>[];
      json['order_histories'].forEach((v) {
        orderHistories!.add(OrderHistories.fromJson(v));
      });
    }
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
    if (json['order_delivery_addresses'] != null) {
      orderDeliveryAddresses = <OrderDeliveryAddresses>[];
      json['order_delivery_addresses'].forEach((v) {
        orderDeliveryAddresses!.add(OrderDeliveryAddresses.fromJson(v));
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
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (deliveryService != null) {
      data['delivery_service'] = deliveryService!.toJson();
    }

    if (orderHistories != null) {
      data['order_histories'] = orderHistories!.map((v) => v.toJson()).toList();
    }
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    if (orderDeliveryAddresses != null) {
      data['order_delivery_addresses'] =
          orderDeliveryAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryService {
  String? deliveryServiceName;
  String? deliveryServiceId;

  DeliveryService({
    this.deliveryServiceName,
    this.deliveryServiceId,
  });

  DeliveryService copyWith({
    String? deliveryServiceName,
    String? deliveryServiceId,
  }) =>
      DeliveryService(
        deliveryServiceName: deliveryServiceName ?? this.deliveryServiceName,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
      );

  factory DeliveryService.fromJson(Map<String, dynamic> json) =>
      DeliveryService(
        deliveryServiceName: json["delivery_service_name"],
        deliveryServiceId: json["delivery_service_id"],
      );

  Map<String, dynamic> toJson() => {
        "delivery_service_name": deliveryServiceName,
        "delivery_service_id": deliveryServiceId,
      };
}

class Store {
  String? storeId;
  String? storeName;
  bool? isVerified;
  bool? isEnabled;
  Image? image;
  Image? logo;

  Store(
      {this.storeId,
      this.storeName,
      this.isVerified,
      this.isEnabled,
      this.image,
      this.logo});

  Store.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    storeName = json['store_name'];
    isVerified = json['is_verified'];
    isEnabled = json['is_enabled'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    logo = json['logo'] != null ? Image.fromJson(json['logo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['is_verified'] = isVerified;
    data['is_enabled'] = isEnabled;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    if (logo != null) {
      data['logo'] = logo!.toJson();
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

class OrderHistories {
  String? orderHistoryId;
  String? orderStatusId;
  String? createdAt;
  String? updatedAt;
  OrderStatus? orderStatus;

  OrderHistories(
      {this.orderHistoryId,
      this.orderStatusId,
      this.createdAt,
      this.updatedAt,
      this.orderStatus});

  OrderHistories.fromJson(Map<String, dynamic> json) {
    orderHistoryId = json['order_history_id'];
    orderStatusId = json['order_status_id'];
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

  OrderItems(
      {this.orderId,
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
      this.orderItemId});

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

  OrderDeliveryAddresses(
      {this.orderId,
      this.stateId,
      this.addressLine1,
      this.addressLine2,
      this.landmark,
      this.city,
      this.postalCode,
      this.orderDeliveryAddressId});

  OrderDeliveryAddresses.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    stateId = json['state_id'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    city = json['city'];
    postalCode = json['postal_code'];
    orderDeliveryAddressId = json['order_delivery_address_id'];
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
    return data;
  }
}

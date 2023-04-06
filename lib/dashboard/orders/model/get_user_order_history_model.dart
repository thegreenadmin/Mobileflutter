class GetUserOrderHistoryModel {
  int? status;
  String? message;
  Data? data;

  GetUserOrderHistoryModel({this.status, this.message, this.data});

  GetUserOrderHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<Order>? orders;

  Data({this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
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
  double? taxValue;
  double? totalTaxCharged;
  double? totalAmount;
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
  List<OrderHistories>? orderHistories;
  List<OrderItems>? orderItems;
  List<OrderDeliveryAddresses>? orderDeliveryAddresses;

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
      this.store,
      this.orderHistories,
      this.orderItems,
      this.orderDeliveryAddresses});

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
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    if (json['order_histories'] != null) {
      orderHistories = <OrderHistories>[];
      json['order_histories'].forEach((v) {
        orderHistories!.add(new OrderHistories.fromJson(v));
      });
    }
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    if (json['order_delivery_addresses'] != null) {
      orderDeliveryAddresses = <OrderDeliveryAddresses>[];
      json['order_delivery_addresses'].forEach((v) {
        orderDeliveryAddresses!.add(new OrderDeliveryAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['delivery_service_id'] = this.deliveryServiceId;
    data['delivery_charge'] = this.deliveryCharge;
    data['tax_type'] = this.taxType;
    data['tax_value'] = this.taxValue;
    data['total_tax_charged'] = this.totalTaxCharged;
    data['total_amount'] = this.totalAmount;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    data['customer_phone_code'] = this.customerPhoneCode;
    data['estimate_delivery_date'] = this.estimateDeliveryDate;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['order_id'] = this.orderId;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.orderHistories != null) {
      data['order_histories'] =
          this.orderHistories!.map((v) => v.toJson()).toList();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.orderDeliveryAddresses != null) {
      data['order_delivery_addresses'] =
          this.orderDeliveryAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    logo = json['logo'] != null ? new Image.fromJson(json['logo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['is_verified'] = this.isVerified;
    data['is_enabled'] = this.isEnabled;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
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
        ? new OrderStatus.fromJson(json['order_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_history_id'] = this.orderHistoryId;
    data['order_status_id'] = this.orderStatusId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.orderStatus != null) {
      data['order_status'] = this.orderStatus!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status_id'] = this.orderStatusId;
    data['order_status_name'] = this.orderStatusName;
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
  int? discountValue;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['order_item_count'] = this.orderItemCount;
    data['order_item_price'] = this.orderItemPrice;
    data['service_charge_type'] = this.serviceChargeType;
    data['service_charge_value'] = this.serviceChargeValue;
    data['total_service_charged'] = this.totalServiceCharged;
    data['discount_name'] = this.discountName;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['total_discount'] = this.totalDiscount;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['order_item_id'] = this.orderItemId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['state_id'] = this.stateId;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['order_delivery_address_id'] = this.orderDeliveryAddressId;
    return data;
  }
}

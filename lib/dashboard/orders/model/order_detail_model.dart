// To parse this JSON data, do
//
//     final orderDetailResponse = orderDetailResponseFromJson(jsonString);

import 'dart:convert';

OrderDetailResponse orderDetailResponseFromJson(String str) => OrderDetailResponse.fromJson(json.decode(str));

String orderDetailResponseToJson(OrderDetailResponse data) => json.encode(data.toJson());

class OrderDetailResponse {
  OrderDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  OrderDetailResponse copyWith({
    dynamic status,
    String? message,
    Data? data,
  }) =>
      OrderDetailResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) => OrderDetailResponse(
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
    this.order,
  });

  OrderDetail? order;

  Data copyWith({
    OrderDetail? order,
  }) =>
      Data(
        order: order ?? this.order,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    order: json["order"] == null ? null : OrderDetail.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order?.toJson(),
  };
}

class OrderDetail {
  OrderDetail({
    this.userId,
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
    this.orderItems,
  });

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
  DateTime? estimateDeliveryDate;
  DateTime? orderDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderId;
  DeliveryService? deliveryService;
  List<OrderHistory>? orderHistories;
  List<OrderDeliveryAddress>? orderDeliveryAddresses;
  List<OrderItem>? orderItems;

  OrderDetail copyWith({
    String? userId,
    String? storeId,
    String? deliveryServiceId,
    dynamic deliveryCharge,
    String? taxType,
    dynamic taxValue,
    dynamic totalTaxCharged,
    dynamic totalAmount,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerPhoneCode,
    DateTime? estimateDeliveryDate,
    DateTime? orderDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderId,
    DeliveryService? deliveryService,
    List<OrderHistory>? orderHistories,
    List<OrderDeliveryAddress>? orderDeliveryAddresses,
    List<OrderItem>? orderItems,
  }) =>
      OrderDetail(
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        taxType: taxType ?? this.taxType,
        taxValue: taxValue ?? this.taxValue,
        totalTaxCharged: totalTaxCharged ?? this.totalTaxCharged,
        totalAmount: totalAmount ?? this.totalAmount,
        customerName: customerName ?? this.customerName,
        customerEmail: customerEmail ?? this.customerEmail,
        customerPhone: customerPhone ?? this.customerPhone,
        customerPhoneCode: customerPhoneCode ?? this.customerPhoneCode,
        estimateDeliveryDate: estimateDeliveryDate ?? this.estimateDeliveryDate,
        orderDate: orderDate ?? this.orderDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderId: orderId ?? this.orderId,
        deliveryService: deliveryService ?? this.deliveryService,
        orderHistories: orderHistories ?? this.orderHistories,
        orderDeliveryAddresses: orderDeliveryAddresses ?? this.orderDeliveryAddresses,
        orderItems: orderItems ?? this.orderItems,
      );

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    userId: json["user_id"],
    storeId: json["store_id"],
    deliveryServiceId: json["delivery_service_id"],
    deliveryCharge: json["delivery_charge"],
    taxType: json["tax_type"],
    taxValue: json["tax_value"]?.toDouble(),
    totalTaxCharged: json["total_tax_charged"]?.toDouble(),
    totalAmount: json["total_amount"]?.toDouble(),
    customerName: json["customer_name"],
    customerEmail: json["customer_email"],
    customerPhone: json["customer_phone"],
    customerPhoneCode: json["customer_phone_code"],
    estimateDeliveryDate: json["estimate_delivery_date"] == null ? null : DateTime.parse(json["estimate_delivery_date"]),
    orderDate: json["order_date"] == null ? null : DateTime.parse(json["order_date"]),
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    orderId: json["order_id"],
    deliveryService: json["delivery_service"] == null ? null : DeliveryService.fromJson(json["delivery_service"]),
    orderHistories: json["order_histories"] == null ? [] : List<OrderHistory>.from(json["order_histories"]!.map((x) => OrderHistory.fromJson(x))),
    orderDeliveryAddresses: json["order_delivery_addresses"] == null ? [] : List<OrderDeliveryAddress>.from(json["order_delivery_addresses"]!.map((x) => OrderDeliveryAddress.fromJson(x))),
    orderItems: json["order_items"] == null ? [] : List<OrderItem>.from(json["order_items"]!.map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "store_id": storeId,
    "delivery_service_id": deliveryServiceId,
    "delivery_charge": deliveryCharge,
    "tax_type": taxType,
    "tax_value": taxValue,
    "total_tax_charged": totalTaxCharged,
    "total_amount": totalAmount,
    "customer_name": customerName,
    "customer_email": customerEmail,
    "customer_phone": customerPhone,
    "customer_phone_code": customerPhoneCode,
    "estimate_delivery_date": estimateDeliveryDate?.toIso8601String(),
    "order_date": orderDate?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "order_id": orderId,
    "delivery_service": deliveryService?.toJson(),
    "order_histories": orderHistories == null ? [] : List<dynamic>.from(orderHistories!.map((x) => x.toJson())),
    "order_delivery_addresses": orderDeliveryAddresses == null ? [] : List<dynamic>.from(orderDeliveryAddresses!.map((x) => x.toJson())),
    "order_items": orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
  };
}

class DeliveryService {
  DeliveryService({
    this.deliveryServiceName,
    this.deliveryServiceId,
  });

  String? deliveryServiceName;
  String? deliveryServiceId;

  DeliveryService copyWith({
    String? deliveryServiceName,
    String? deliveryServiceId,
  }) =>
      DeliveryService(
        deliveryServiceName: deliveryServiceName ?? this.deliveryServiceName,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
      );

  factory DeliveryService.fromJson(Map<String, dynamic> json) => DeliveryService(
    deliveryServiceName: json["delivery_service_name"],
    deliveryServiceId: json["delivery_service_id"],
  );

  Map<String, dynamic> toJson() => {
    "delivery_service_name": deliveryServiceName,
    "delivery_service_id": deliveryServiceId,
  };
}

class OrderDeliveryAddress {
  OrderDeliveryAddress({
    this.orderId,
    this.stateId,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.postalCode,
    this.orderDeliveryAddressId,
    this.state,
  });

  String? orderId;
  String? stateId;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? postalCode;
  String? orderDeliveryAddressId;
  State? state;

  OrderDeliveryAddress copyWith({
    String? orderId,
    String? stateId,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? city,
    String? postalCode,
    String? orderDeliveryAddressId,
    State? state,
  }) =>
      OrderDeliveryAddress(
        orderId: orderId ?? this.orderId,
        stateId: stateId ?? this.stateId,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        landmark: landmark ?? this.landmark,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        orderDeliveryAddressId: orderDeliveryAddressId ?? this.orderDeliveryAddressId,
        state: state ?? this.state,
      );

  factory OrderDeliveryAddress.fromJson(Map<String, dynamic> json) => OrderDeliveryAddress(
    orderId: json["order_id"],
    stateId: json["state_id"],
    addressLine1: json["address_line_1"],
    addressLine2: json["address_line_2"],
    landmark: json["landmark"],
    city: json["city"],
    postalCode: json["postal_code"],
    orderDeliveryAddressId: json["order_delivery_address_id"],
    state: json["state"] == null ? null : State.fromJson(json["state"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "state_id": stateId,
    "address_line_1": addressLine1,
    "address_line_2": addressLine2,
    "landmark": landmark,
    "city": city,
    "postal_code": postalCode,
    "order_delivery_address_id": orderDeliveryAddressId,
    "state": state?.toJson(),
  };
}

class State {
  State({
    this.stateId,
    this.stateName,
    this.country,
  });

  String? stateId;
  String? stateName;
  Country? country;

  State copyWith({
    String? stateId,
    String? stateName,
    Country? country,
  }) =>
      State(
        stateId: stateId ?? this.stateId,
        stateName: stateName ?? this.stateName,
        country: country ?? this.country,
      );

  factory State.fromJson(Map<String, dynamic> json) => State(
    stateId: json["state_id"],
    stateName: json["state_name"],
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
  );

  Map<String, dynamic> toJson() => {
    "state_id": stateId,
    "state_name": stateName,
    "country": country?.toJson(),
  };
}

class Country {
  Country({
    this.countryId,
    this.countryName,
  });

  String? countryId;
  String? countryName;

  Country copyWith({
    String? countryId,
    String? countryName,
  }) =>
      Country(
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
      );

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    countryId: json["country_id"],
    countryName: json["country_name"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId,
    "country_name": countryName,
  };
}

class OrderHistory {
  OrderHistory({
    this.orderHistoryId,
    this.orderStatusId,
    this.isCurrentStatus,
    this.createdAt,
    this.updatedAt,
    this.orderStatus,
  });

  String? orderHistoryId;
  String? orderStatusId;
  bool? isCurrentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  OrderStatus? orderStatus;

  OrderHistory copyWith({
    String? orderHistoryId,
    String? orderStatusId,
    bool? isCurrentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderStatus? orderStatus,
  }) =>
      OrderHistory(
        orderHistoryId: orderHistoryId ?? this.orderHistoryId,
        orderStatusId: orderStatusId ?? this.orderStatusId,
        isCurrentStatus: isCurrentStatus ?? this.isCurrentStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderStatus: orderStatus ?? this.orderStatus,
      );

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    orderHistoryId: json["order_history_id"],
    orderStatusId: json["order_status_id"],
    isCurrentStatus: json["is_current_status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    orderStatus: json["order_status"] == null ? null : OrderStatus.fromJson(json["order_status"]),
  );

  Map<String, dynamic> toJson() => {
    "order_history_id": orderHistoryId,
    "order_status_id": orderStatusId,
    "is_current_status": isCurrentStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "order_status": orderStatus?.toJson(),
  };
}

class OrderStatus {
  OrderStatus({
    this.orderStatusId,
    this.orderStatusName,
  });

  String? orderStatusId;
  String? orderStatusName;

  OrderStatus copyWith({
    String? orderStatusId,
    String? orderStatusName,
  }) =>
      OrderStatus(
        orderStatusId: orderStatusId ?? this.orderStatusId,
        orderStatusName: orderStatusName ?? this.orderStatusName,
      );

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    orderStatusId: json["order_status_id"],
    orderStatusName: json["order_status_name"],
  );

  Map<String, dynamic> toJson() => {
    "order_status_id": orderStatusId,
    "order_status_name": orderStatusName,
  };
}

class OrderItem {
  OrderItem({
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
  });

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
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderItemId;
  Product? product;

  OrderItem copyWith({
    String? orderId,
    String? productId,
    dynamic orderItemCount,
    dynamic orderItemPrice,
    String? serviceChargeType,
    dynamic serviceChargeValue,
    dynamic totalServiceCharged,
    String? discountName,
    String? discountType,
    dynamic discountValue,
    dynamic totalDiscount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderItemId,
    Product? product,
  }) =>
      OrderItem(
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        orderItemCount: orderItemCount ?? this.orderItemCount,
        orderItemPrice: orderItemPrice ?? this.orderItemPrice,
        serviceChargeType: serviceChargeType ?? this.serviceChargeType,
        serviceChargeValue: serviceChargeValue ?? this.serviceChargeValue,
        totalServiceCharged: totalServiceCharged ?? this.totalServiceCharged,
        discountName: discountName ?? this.discountName,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderItemId: orderItemId ?? this.orderItemId,
        product: product ?? this.product,
      );

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    orderId: json["order_id"],
    productId: json["product_id"],
    orderItemCount: json["order_item_count"],
    orderItemPrice: json["order_item_price"],
    serviceChargeType: json["service_charge_type"],
    serviceChargeValue: json["service_charge_value"]?.toDouble(),
    totalServiceCharged: json["total_service_charged"]?.toDouble(),
    discountName: json["discount_name"],
    discountType: json["discount_type"],
    discountValue: json["discount_value"],
    totalDiscount: json["total_discount"]?.toDouble(),
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    orderItemId: json["order_item_id"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "product_id": productId,
    "order_item_count": orderItemCount,
    "order_item_price": orderItemPrice,
    "service_charge_type": serviceChargeType,
    "service_charge_value": serviceChargeValue,
    "total_service_charged": totalServiceCharged,
    "discount_name": discountName,
    "discount_type": discountType,
    "discount_value": discountValue,
    "total_discount": totalDiscount,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "order_item_id": orderItemId,
    "product": product?.toJson(),
  };
}

class Product {
  Product({
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
    this.productId,
    this.productReviews,
    this.productImages,
  });

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
  String? productId;
  List<dynamic>? productReviews;
  List<dynamic>? productImages;

  Product copyWith({
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
    String? productId,
    List<dynamic>? productReviews,
    List<dynamic>? productImages,
  }) =>
      Product(
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
        productId: productId ?? this.productId,
        productReviews: productReviews ?? this.productReviews,
        productImages: productImages ?? this.productImages,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    productId: json["product_id"],
    productReviews: json["product_reviews"] == null ? [] : List<dynamic>.from(json["product_reviews"]!.map((x) => x)),
    productImages: json["product_images"] == null ? [] : List<dynamic>.from(json["product_images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
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
    "product_id": productId,
    "product_reviews": productReviews == null ? [] : List<dynamic>.from(productReviews!.map((x) => x)),
    "product_images": productImages == null ? [] : List<dynamic>.from(productImages!.map((x) => x)),
  };
}

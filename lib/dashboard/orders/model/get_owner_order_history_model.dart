import 'orders_model.dart';

class GetOwnerOrderHistoryModel {
  dynamic status;
  String? message;
  OwnerOrderHistoryData? data;

  GetOwnerOrderHistoryModel({this.status, this.message, this.data});

  GetOwnerOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? OwnerOrderHistoryData.fromJson(json['data'])
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

class OwnerOrderHistoryData {
  dynamic totalCount;
  List<Orders>? orders;
  dynamic userProof;
  OwnerOrderHistoryData({
    this.totalCount,
    this.orders,
    this.userProof,
  });

  OwnerOrderHistoryData.fromJson(Map<String, dynamic> json) {
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
  List<OrderTransactions>? orderTransactions;
  Store? store;
  DeliveryService? deliveryService;
  List<OrderHistories>? orderHistories;
  List<OrderItem>? orderItems;
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
      this.orderTransactions,
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
    if (json['order_transactions'] != null) {
      orderTransactions = <OrderTransactions>[];
      json['order_transactions'].forEach((v) {
        orderTransactions!.add(new OrderTransactions.fromJson(v));
      });
    }
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
      orderItems = <OrderItem>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
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
    if (this.orderTransactions != null) {
      data['order_transactions'] =
          this.orderTransactions!.map((v) => v.toJson()).toList();
    }
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

class OrderTransactions {
  String? transactionId;
  String? orderId;
  String? orderTransactionType;
  String? storeServiceChargeType;
  dynamic storeServiceChargeValue;
  dynamic storeTotalServiceCharged;
  String? orderServiceChargeType;
  int? orderServiceChargeValue;
  dynamic orderTotalServiceCharged;
  dynamic storeReceivedAmount;
  dynamic totalAmount;
  String? orderTransactionId;

  OrderTransactions(
      {this.transactionId,
      this.orderId,
      this.orderTransactionType,
      this.storeServiceChargeType,
      this.storeServiceChargeValue,
      this.storeTotalServiceCharged,
      this.orderServiceChargeType,
      this.orderServiceChargeValue,
      this.orderTotalServiceCharged,
      this.storeReceivedAmount,
      this.totalAmount,
      this.orderTransactionId});

  OrderTransactions.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    orderTransactionType = json['order_transaction_type'];
    storeServiceChargeType = json['store_service_charge_type'];
    storeServiceChargeValue = json['store_service_charge_value'];
    storeTotalServiceCharged = json['store_total_service_charged'];
    orderServiceChargeType = json['order_service_charge_type'];
    orderServiceChargeValue = json['order_service_charge_value'];
    orderTotalServiceCharged = json['order_total_service_charged'];
    storeReceivedAmount = json['store_received_amount'];
    totalAmount = json['total_amount'];
    orderTransactionId = json['order_transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    data['order_transaction_type'] = this.orderTransactionType;
    data['store_service_charge_type'] = this.storeServiceChargeType;
    data['store_service_charge_value'] = this.storeServiceChargeValue;
    data['store_total_service_charged'] = this.storeTotalServiceCharged;
    data['order_service_charge_type'] = this.orderServiceChargeType;
    data['order_service_charge_value'] = this.orderServiceChargeValue;
    data['order_total_service_charged'] = this.orderTotalServiceCharged;
    data['store_received_amount'] = this.storeReceivedAmount;
    data['total_amount'] = this.totalAmount;
    data['order_transaction_id'] = this.orderTransactionId;
    return data;
  }
}

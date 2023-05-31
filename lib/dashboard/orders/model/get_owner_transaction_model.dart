class GetOwnerTransactionModel {
  int? status;
  String? message;
  Data? data;

  GetOwnerTransactionModel({this.status, this.message, this.data});

  GetOwnerTransactionModel.fromJson(Map<String, dynamic> json) {
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
  List<Transactions>? transactions;

  Data({this.totalCount, this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? storeId;
  String? orderTransactionId;
  String? orderItemRefundTransactionId;
  String? storePayoutId;
  dynamic netBalance;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storeWalletTransactionId;
  Store? store;
  OrderTransaction? orderTransaction;
  OrderItemRefundTransaction? orderItemRefundTransaction;
  dynamic storePayout;

  Transactions(
      {this.storeId,
      this.orderTransactionId,
      this.orderItemRefundTransactionId,
      this.storePayoutId,
      this.netBalance,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.storeWalletTransactionId,
      this.store,
      this.orderTransaction,
      this.orderItemRefundTransaction,
      this.storePayout});

  Transactions.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    orderTransactionId = json['order_transaction_id'];
    orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
    storePayoutId = json['store_payout_id'];
    netBalance = json['net_balance'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    storeWalletTransactionId = json['store_wallet_transaction_id'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    orderTransaction = json['order_transaction'] != null
        ? OrderTransaction.fromJson(json['order_transaction'])
        : null;
    orderItemRefundTransaction = json['order_item_refund_transaction'] != null
        ? OrderItemRefundTransaction.fromJson(
            json['order_item_refund_transaction'])
        : null;
    storePayout = json['store_payout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['order_transaction_id'] = orderTransactionId;
    data['order_item_refund_transaction_id'] = orderItemRefundTransactionId;
    data['store_payout_id'] = storePayoutId;
    data['net_balance'] = netBalance;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['store_wallet_transaction_id'] = storeWalletTransactionId;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (orderTransaction != null) {
      data['order_transaction'] = orderTransaction!.toJson();
    }
    if (orderItemRefundTransaction != null) {
      data['order_item_refund_transaction'] =
          orderItemRefundTransaction!.toJson();
    }
    data['store_payout'] = storePayout;
    return data;
  }
}

class Store {
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storeEmail;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  dynamic verifiedBy;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storeId;
  Image? image;
  Image? logo;

  Store(
      {this.storeName,
      this.storeEin,
      this.storeNickName,
      this.storeEmail,
      this.storePhone,
      this.storePhoneCode,
      this.isVerified,
      this.verifiedBy,
      this.isEnabled,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.storeId,
      this.image,
      this.logo});

  Store.fromJson(Map<String, dynamic> json) {
    storeName = json['store_name'];
    storeEin = json['store_ein'];
    storeNickName = json['store_nick_name'];
    storeEmail = json['store_email'];
    storePhone = json['store_phone'];
    storePhoneCode = json['store_phone_code'];
    isVerified = json['is_verified'];
    verifiedBy = json['verified_by'];
    isEnabled = json['is_enabled'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    storeId = json['store_id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    logo = json['logo'] != null ? Image.fromJson(json['logo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_name'] = storeName;
    data['store_ein'] = storeEin;
    data['store_nick_name'] = storeNickName;
    data['store_email'] = storeEmail;
    data['store_phone'] = storePhone;
    data['store_phone_code'] = storePhoneCode;
    data['is_verified'] = isVerified;
    data['verified_by'] = verifiedBy;
    data['is_enabled'] = isEnabled;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['store_id'] = storeId;
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

class OrderTransaction {
  String? orderTransactionId;
  String? orderId;
  Order? order;
  Transaction? transaction;

  OrderTransaction(
      {this.orderTransactionId, this.orderId, this.order, this.transaction});

  OrderTransaction.fromJson(Map<String, dynamic> json) {
    orderTransactionId = json['order_transaction_id'];
    orderId = json['order_id'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_transaction_id'] = orderTransactionId;
    data['order_id'] = orderId;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
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
      this.orderId});

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
    return data;
  }
}

class Transaction {
  String? paymentServiceId;
  String? stripeTransactionId;
  String? transactionType;
  dynamic transactionAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? transactionId;

  Transaction(
      {this.paymentServiceId,
      this.stripeTransactionId,
      this.transactionType,
      this.transactionAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.transactionId});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentServiceId = json['payment_service_id'];
    stripeTransactionId = json['stripe_transaction_id'];
    transactionType = json['transaction_type'];
    transactionAmount = json['transaction_amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_service_id'] = paymentServiceId;
    data['stripe_transaction_id'] = stripeTransactionId;
    data['transaction_type'] = transactionType;
    data['transaction_amount'] = transactionAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['transaction_id'] = transactionId;
    return data;
  }
}

class OrderItemRefundTransaction {
  String? transactionId;
  String? returnOrderItemId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderItemRefundTransactionId;
  ReturnOrderItem? returnOrderItem;
  Transaction? transaction;

  OrderItemRefundTransaction(
      {this.transactionId,
      this.returnOrderItemId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.orderItemRefundTransactionId,
      this.returnOrderItem,
      this.transaction});

  OrderItemRefundTransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    returnOrderItemId = json['return_order_item_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
    returnOrderItem = json['return_order_item'] != null
        ? ReturnOrderItem.fromJson(json['return_order_item'])
        : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['return_order_item_id'] = returnOrderItemId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['order_item_refund_transaction_id'] = orderItemRefundTransactionId;
    if (returnOrderItem != null) {
      data['return_order_item'] = returnOrderItem!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class ReturnOrderItem {
  String? orderItemId;
  String? remarks;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? returnItemId;

  ReturnOrderItem(
      {this.orderItemId,
      this.remarks,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.returnItemId});

  ReturnOrderItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['order_item_id'];
    remarks = json['remarks'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    returnItemId = json['return_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_item_id'] = orderItemId;
    data['remarks'] = remarks;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['return_item_id'] = returnItemId;
    return data;
  }
}

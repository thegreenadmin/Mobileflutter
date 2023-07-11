import 'orders_model.dart';

class GetOwnerTransactionModel {
  int? status;
  String? message;
  OwnerTransactionData? data;

  GetOwnerTransactionModel({this.status, this.message, this.data});

  GetOwnerTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? OwnerTransactionData.fromJson(json['data'])
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

class OwnerTransactionData {
  int? totalCount;
  List<Transactions>? transactions;

  OwnerTransactionData({this.totalCount, this.transactions});

  OwnerTransactionData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
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
  StorePayout? storePayout;

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
    storePayout = json['store_payout'] != null
        ? StorePayout.fromJson(json['store_payout'])
        : null;
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
    if (storePayout != null) {
      data['store_payout'] = storePayout!.toJson();
    }
    return data;
  }
}

class OrderTransaction {
  String? id;
  String? transactionId;
  String? orderId;
  String? orderTransactionType;
  String? storeServiceChargeType;
  double? storeServiceChargeValue;
  double? storeTotalServiceCharged;
  String? orderServiceChargeType;
  dynamic orderServiceChargeValue;
  dynamic orderTotalServiceCharged;
  dynamic storeReceivedAmount;
  dynamic totalAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderTransactionId;
  Order? order;
  Transaction? transaction;

  OrderTransaction(
      {this.id,
      this.transactionId,
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
      this.status,
      this.createdAt,
      this.updatedAt,
      this.orderTransactionId,
      this.order,
      this.transaction});

  OrderTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderTransactionId = json['order_transaction_id'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['order_id'] = orderId;
    data['order_transaction_type'] = orderTransactionType;
    data['store_service_charge_type'] = storeServiceChargeType;
    data['store_service_charge_value'] = storeServiceChargeValue;
    data['store_total_service_charged'] = storeTotalServiceCharged;
    data['order_service_charge_type'] = orderServiceChargeType;
    data['order_service_charge_value'] = orderServiceChargeValue;
    data['order_total_service_charged'] = orderTotalServiceCharged;
    data['store_received_amount'] = storeReceivedAmount;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['order_transaction_id'] = orderTransactionId;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class OrderItemRefundTransaction {
  String? transactionId;
  String? orderItemId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderItemRefundTransactionId;
  OrderItem? orderItem;
  Transactionn? transaction;
  ReturnOrderItem? returnOrderItem;

  OrderItemRefundTransaction({
    this.transactionId,
    this.orderItemId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderItemRefundTransactionId,
    this.orderItem,
    this.transaction,
    this.returnOrderItem,
  });

  OrderItemRefundTransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderItemId = json['order_item_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
    orderItem = json['order_item'] != null
        ? OrderItem.fromJson(json['order_item'])
        : null;
    transaction = json['transaction'] != null
        ? Transactionn.fromJson(json['transaction'])
        : null;
    returnOrderItem = json['return_order_item'] != null
        ? ReturnOrderItem.fromJson(json['return_order_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['order_item_id'] = orderItemId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['order_item_refund_transaction_id'] = orderItemRefundTransactionId;
    if (orderItem != null) {
      data['order_item'] = orderItem!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    if (returnOrderItem != null) {
      data['return_order_item'] = returnOrderItem!.toJson();
    }
    return data;
  }
}

class Transactionn {
  String? paymentServiceId;
  String? transactionType;
  dynamic transactionAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? transactionId;

  Transactionn(
      {this.paymentServiceId,
      this.transactionType,
      this.transactionAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.transactionId});

  Transactionn.fromJson(Map<String, dynamic> json) {
    paymentServiceId = json['payment_service_id'];
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
    data['transaction_type'] = transactionType;
    data['transaction_amount'] = transactionAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['transaction_id'] = transactionId;
    return data;
  }
}

class StorePayout {
  String? transactionId;
  String? userStripeBankId;
  dynamic transferedAmount;
  dynamic totalTransactionAmount;
  dynamic reversedAmount;
  dynamic totalReversedAmount;
  String? payoutType;
  dynamic isReversed;
  String? stripeTransferId;
  String? stripePayoutId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storePayoutId;

  StorePayout(
      {this.transactionId,
      this.userStripeBankId,
      this.transferedAmount,
      this.totalTransactionAmount,
      this.reversedAmount,
      this.totalReversedAmount,
      this.payoutType,
      this.isReversed,
      this.stripeTransferId,
      this.stripePayoutId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.storePayoutId});

  StorePayout.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    userStripeBankId = json['user_stripe_bank_id'];
    transferedAmount = json['transfered_amount'];
    totalTransactionAmount = json['total_transaction_amount'];
    reversedAmount = json['reversed_amount'];
    totalReversedAmount = json['total_reversed_amount'];
    payoutType = json['payout_type'];
    isReversed = json['is_reversed'];
    stripeTransferId = json['stripe_transfer_id'];
    stripePayoutId = json['stripe_payout_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    storePayoutId = json['store_payout_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['user_stripe_bank_id'] = userStripeBankId;
    data['transfered_amount'] = transferedAmount;
    data['total_transaction_amount'] = totalTransactionAmount;
    data['reversed_amount'] = reversedAmount;
    data['total_reversed_amount'] = totalReversedAmount;
    data['payout_type'] = payoutType;
    data['is_reversed'] = isReversed;
    data['stripe_transfer_id'] = stripeTransferId;
    data['stripe_payout_id'] = stripePayoutId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['store_payout_id'] = storePayoutId;
    return data;
  }
}

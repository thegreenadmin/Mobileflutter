import 'orders_model.dart';

class GetUserTransactionModel {
  dynamic status;
  String? message;
  UserTransactionData? data;

  GetUserTransactionModel({this.status, this.message, this.data});

  GetUserTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? UserTransactionData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserTransactionData {
  dynamic totalCount;
  List<Transactionss>? transactions;

  UserTransactionData({this.totalCount, this.transactions});

  UserTransactionData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['transactions'] != null) {
      transactions = <Transactionss>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactionss.fromJson(v));
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

class Transactionss {
  String? userId;
  String? orderTranscationId;
  String? orderItemRefundTransactionId;
  String? transactionId;
  String? userStripeCardId;
  dynamic netBalance;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userWalletTransactionId;
  OrderTransaction? orderTransaction;
  OrderItemRefundTransaction? orderItemRefundTransaction;
  Transaction? transaction;
  Store? store;
  Membership? membership;

  Transactionss(
      {this.userId,
      this.orderTranscationId,
      this.orderItemRefundTransactionId,
      this.transactionId,
      this.userStripeCardId,
      this.netBalance,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userWalletTransactionId,
      this.orderTransaction,
      this.orderItemRefundTransaction,
      this.transaction,
      this.store,
      this.membership});

  Transactionss.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    orderTranscationId = json['order_transcation_id'];
    orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
    transactionId = json['transaction_id'];
    userStripeCardId = json['user_stripe_card_id'];
    netBalance = json['net_balance'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userWalletTransactionId = json['user_wallet_transaction_id'];
    orderTransaction = json['order_transaction'] != null
        ? OrderTransaction.fromJson(json['order_transaction'])
        : null;
    orderItemRefundTransaction = json['order_item_refund_transaction'] != null
        ? OrderItemRefundTransaction.fromJson(
            json['order_item_refund_transaction'])
        : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    membership = json['membership'] != null
        ? Membership.fromJson(json['membership'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['order_transcation_id'] = orderTranscationId;
    data['order_item_refund_transaction_id'] = orderItemRefundTransactionId;
    data['transaction_id'] = transactionId;
    data['user_stripe_card_id'] = userStripeCardId;
    data['net_balance'] = netBalance;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user_wallet_transaction_id'] = userWalletTransactionId;
    if (orderTransaction != null) {
      data['order_transaction'] = orderTransaction!.toJson();
    }
    if (orderItemRefundTransaction != null) {
      data['order_item_refund_transaction'] =
          orderItemRefundTransaction!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (membership != null) {
      data['membership'] = membership!.toJson();
    }
    return data;
  }
}

class Transaction {
  String? paymentServiceId;
  String? stripePaymentIntentTransactionId;
  String? stripePayoutTransactionId;
  String? transactionType;
  dynamic transactionAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? transactionId;
  PaymentService? paymentService;
  List<TransactionHistories>? transactionHistories;

  Transaction(
      {this.paymentServiceId,
      this.stripePaymentIntentTransactionId,
      this.stripePayoutTransactionId,
      this.transactionType,
      this.transactionAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.transactionId,
      this.paymentService,
      this.transactionHistories});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentServiceId = json['payment_service_id'];
    stripePaymentIntentTransactionId =
        json['stripe_payment_intent_transaction_id'];
    stripePayoutTransactionId = json['stripe_payout_transaction_id'];
    transactionType = json['transaction_type'];
    transactionAmount = json['transaction_amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    transactionId = json['transaction_id'];
    paymentService = json['payment_service'] != null
        ? PaymentService.fromJson(json['payment_service'])
        : null;
    if (json['transaction_histories'] != null) {
      transactionHistories = <TransactionHistories>[];
      json['transaction_histories'].forEach((v) {
        transactionHistories!.add(TransactionHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_service_id'] = paymentServiceId;
    data['stripe_payment_intent_transaction_id'] =
        stripePaymentIntentTransactionId;
    data['stripe_payout_transaction_id'] = stripePayoutTransactionId;
    data['transaction_type'] = transactionType;
    data['transaction_amount'] = transactionAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['transaction_id'] = transactionId;
    if (paymentService != null) {
      data['payment_service'] = paymentService!.toJson();
    }
    if (transactionHistories != null) {
      data['transaction_histories'] =
          transactionHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentService {
  String? paymentServiceId;
  String? paymentServiceName;

  PaymentService({this.paymentServiceId, this.paymentServiceName});

  PaymentService.fromJson(Map<String, dynamic> json) {
    paymentServiceId = json['payment_service_id'];
    paymentServiceName = json['payment_service_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_service_id'] = paymentServiceId;
    data['payment_service_name'] = paymentServiceName;
    return data;
  }
}

class TransactionHistories {
  String? transactionId;
  String? transactionStatus;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? transactionHistoryId;

  TransactionHistories(
      {this.transactionId,
      this.transactionStatus,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.transactionHistoryId});

  TransactionHistories.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    transactionStatus = json['transaction_status'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    transactionHistoryId = json['transaction_history_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['transaction_status'] = transactionStatus;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['transaction_history_id'] = transactionHistoryId;
    return data;
  }
}

class ReturnOrderItem {
  String? orderItemId;
  dynamic returnItemsCount;
  String? remarks;
  dynamic totalTaxReversed;
  dynamic totalAmountReversed;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? returnOrderItemId;
  OrderItem? orderItem;

  ReturnOrderItem(
      {this.orderItemId,
      this.returnItemsCount,
      this.remarks,
      this.totalTaxReversed,
      this.totalAmountReversed,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.returnOrderItemId,
      this.orderItem});

  ReturnOrderItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['order_item_id'];
    returnItemsCount = json['return_items_count'];
    remarks = json['remarks'];
    totalTaxReversed = json['total_tax_reversed'];
    totalAmountReversed = json['total_amount_reversed'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    returnOrderItemId = json['return_order_item_id'];
    orderItem = json['order_item'] != null
        ? OrderItem.fromJson(json['order_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_item_id'] = orderItemId;
    data['return_items_count'] = returnItemsCount;
    data['remarks'] = remarks;
    data['total_tax_reversed'] = totalTaxReversed;
    data['total_amount_reversed'] = totalAmountReversed;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['return_order_item_id'] = returnOrderItemId;
    if (orderItem != null) {
      data['order_item'] = orderItem!.toJson();
    }
    return data;
  }
}

class TransactionList {
  String? paymentServiceId;
  String? stripePaymentIntentTransactionId;
  String? stripePayoutTransactionId;
  String? transactionType;
  dynamic transactionAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? transactionId;
  PaymentService? paymentService;
  List<TransactionHistories>? transactionHistories;

  TransactionList(
      {this.paymentServiceId,
      this.stripePaymentIntentTransactionId,
      this.stripePayoutTransactionId,
      this.transactionType,
      this.transactionAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.transactionId,
      this.paymentService,
      this.transactionHistories});

  TransactionList.fromJson(Map<String, dynamic> json) {
    paymentServiceId = json['payment_service_id'];
    stripePaymentIntentTransactionId =
        json['stripe_payment_intent_transaction_id'];
    stripePayoutTransactionId = json['stripe_payout_transaction_id'];
    transactionType = json['transaction_type'];
    transactionAmount = json['transaction_amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    transactionId = json['transaction_id'];
    paymentService = json['payment_service'] != null
        ? PaymentService.fromJson(json['payment_service'])
        : null;
    if (json['transaction_histories'] != null) {
      transactionHistories = <TransactionHistories>[];
      json['transaction_histories'].forEach((v) {
        transactionHistories!.add(TransactionHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_service_id'] = paymentServiceId;
    data['stripe_payment_intent_transaction_id'] =
        stripePaymentIntentTransactionId;
    data['stripe_payout_transaction_id'] = stripePayoutTransactionId;
    data['transaction_type'] = transactionType;
    data['transaction_amount'] = transactionAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['transaction_id'] = transactionId;
    if (paymentService != null) {
      data['payment_service'] = paymentService!.toJson();
    }
    if (transactionHistories != null) {
      data['transaction_histories'] =
          transactionHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Membership {
  String? membershipId;
  String? transactionId;
  String? membershipPlanId;
  dynamic membershipCharge;
  dynamic duration;
  String? expiredAt;
  MembershipPlan? membershipPlan;
  Transaction? transaction;

  Membership(
      {this.membershipId,
      this.transactionId,
      this.membershipPlanId,
      this.membershipCharge,
      this.duration,
      this.expiredAt,
      this.membershipPlan,
      this.transaction});

  Membership.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    transactionId = json['transaction_id'];
    membershipPlanId = json['membership_plan_id'];
    membershipCharge = json['membership_charge'];
    duration = json['duration'];
    expiredAt = json['expiredAt'];
    membershipPlan = json['membership_plan'] != null
        ? MembershipPlan.fromJson(json['membership_plan'])
        : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['transaction_id'] = transactionId;
    data['membership_plan_id'] = membershipPlanId;
    data['membership_charge'] = membershipCharge;
    data['duration'] = duration;
    data['expiredAt'] = expiredAt;
    if (membershipPlan != null) {
      data['membership_plan'] = membershipPlan!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

/*class MembershipPlan {
  String? id;
  String? planName;
  String? planType;
   dynamic plan30Charge;
   dynamic plan90Charge;
   dynamic plan180Charge;
   dynamic plan365Charge;
  String? planDescription;
  String? status;
  String? createdAt;
  String? updatedAt;

  MembershipPlan(
      {this.id,
      this.planName,
      this.planType,
      this.plan30Charge,
      this.plan90Charge,
      this.plan180Charge,
      this.plan365Charge,
      this.planDescription,
      this.status,
      this.createdAt,
      this.updatedAt});

  MembershipPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    planType = json['plan_type'];
    plan30Charge = json['plan_30_charge'];
    plan90Charge = json['plan_90_charge'];
    plan180Charge = json['plan_180_charge'];
    plan365Charge = json['plan_365_charge'];
    planDescription = json['plan_description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName;
    data['plan_type'] = planType;
    data['plan_30_charge'] = plan30Charge;
    data['plan_90_charge'] = plan90Charge;
    data['plan_180_charge'] = plan180Charge;
    data['plan_365_charge'] = plan365Charge;
    data['plan_description'] = planDescription;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}*/

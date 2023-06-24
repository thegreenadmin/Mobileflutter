class GetUserTransactionModel {
  int? status;
  String? message;
  Data? data;

  GetUserTransactionModel({this.status, this.message, this.data});

  GetUserTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? totalCount;
  List<Transactionss>? transactions;

  Data({this.totalCount, this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
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
        ? new Membership.fromJson(json['membership'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['order_transcation_id'] = this.orderTranscationId;
    data['order_item_refund_transaction_id'] =
        this.orderItemRefundTransactionId;
    data['transaction_id'] = this.transactionId;
    data['user_stripe_card_id'] = this.userStripeCardId;
    data['net_balance'] = this.netBalance;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_wallet_transaction_id'] = this.userWalletTransactionId;
    if (this.orderTransaction != null) {
      data['order_transaction'] = this.orderTransaction!.toJson();
    }
    if (this.orderItemRefundTransaction != null) {
      data['order_item_refund_transaction'] =
          this.orderItemRefundTransaction!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.membership != null) {
      data['membership'] = this.membership!.toJson();
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
  double? orderServiceChargeValue;
  double? orderTotalServiceCharged;
  double? storeReceivedAmount;
  double? totalAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderTransactionId;
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
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['payment_service_id'] = this.paymentServiceId;
    data['stripe_payment_intent_transaction_id'] =
        this.stripePaymentIntentTransactionId;
    data['stripe_payout_transaction_id'] = this.stripePayoutTransactionId;
    data['transaction_type'] = this.transactionType;
    data['transaction_amount'] = this.transactionAmount;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['transaction_id'] = this.transactionId;
    if (this.paymentService != null) {
      data['payment_service'] = this.paymentService!.toJson();
    }
    if (this.transactionHistories != null) {
      data['transaction_histories'] =
          this.transactionHistories!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['payment_service_id'] = this.paymentServiceId;
    data['payment_service_name'] = this.paymentServiceName;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['transaction_status'] = this.transactionStatus;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['transaction_history_id'] = this.transactionHistoryId;
    return data;
  }
}

class OrderItemRefundTransaction {
  String? orderItemRefundTransactionId;
  String? transactionId;
  ReturnOrderItem? returnOrderItem;
  Transaction? transaction;

  OrderItemRefundTransaction(
      {this.orderItemRefundTransactionId,
      this.transactionId,
      this.returnOrderItem,
      this.transaction});

  OrderItemRefundTransaction.fromJson(Map<String, dynamic> json) {
    orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
    transactionId = json['transaction_id'];
    returnOrderItem = json['return_order_item'] != null
        ? ReturnOrderItem.fromJson(json['return_order_item'])
        : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_item_refund_transaction_id'] =
        this.orderItemRefundTransactionId;
    data['transaction_id'] = this.transactionId;
    if (this.returnOrderItem != null) {
      data['return_order_item'] = this.returnOrderItem!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class ReturnOrderItem {
  String? orderItemId;
  int? returnItemsCount;
  String? remarks;
  double? totalTaxReversed;
  double? totalAmountReversed;
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

class OrderItem {
  String? orderId;
  String? productId;
  int? orderItemCount;
  int? orderItemPrice;
  String? serviceChargeType;
  double? serviceChargeValue;
  double? totalServiceCharged;
  String? discountName;
  String? discountType;
  int? discountValue;
  double? totalDiscount;
  String? orderItemStatus;
  String? cancelledAt;
  String? shippedAt;
  String? deliveredAt;
  String? returedAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderItemId;

  OrderItem(
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
      this.orderItemStatus,
      this.cancelledAt,
      this.shippedAt,
      this.deliveredAt,
      this.returedAt,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.orderItemId});

  OrderItem.fromJson(Map<String, dynamic> json) {
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
    orderItemStatus = json['order_item_status'];
    cancelledAt = json['cancelledAt'];
    shippedAt = json['shippedAt'];
    deliveredAt = json['deliveredAt'];
    returedAt = json['returedAt'];
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
    data['order_item_status'] = orderItemStatus;
    data['cancelledAt'] = cancelledAt;
    data['shippedAt'] = shippedAt;
    data['deliveredAt'] = deliveredAt;
    data['returedAt'] = returedAt;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['order_item_id'] = orderItemId;
    return data;
  }
}

class TransactionList {
  String? paymentServiceId;
  String? stripePaymentIntentTransactionId;
  String? stripePayoutTransactionId;
  String? transactionType;
  int? transactionAmount;
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

class Store {
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storeEmail;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  String? verifiedBy;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storeId;
  Logo? logo;
  Logo? image;

  Store(
      {storeName,
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
      this.logo,
      this.image});

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
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    image = json['image'] != null ? Logo.fromJson(json['image']) : null;
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
    if (logo != null) {
      data['logo'] = logo!.toJson();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Membership {
  String? membershipId;
  String? transactionId;
  String? membershipPlanId;
  int? membershipCharge;
  int? duration;
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
        ? new MembershipPlan.fromJson(json['membership_plan'])
        : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_id'] = this.membershipId;
    data['transaction_id'] = this.transactionId;
    data['membership_plan_id'] = this.membershipPlanId;
    data['membership_charge'] = this.membershipCharge;
    data['duration'] = this.duration;
    data['expiredAt'] = this.expiredAt;
    if (this.membershipPlan != null) {
      data['membership_plan'] = this.membershipPlan!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class MembershipPlan {
  String? id;
  String? planName;
  String? planType;
  int? plan30Charge;
  int? plan90Charge;
  int? plan180Charge;
  int? plan365Charge;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_name'] = this.planName;
    data['plan_type'] = this.planType;
    data['plan_30_charge'] = this.plan30Charge;
    data['plan_90_charge'] = this.plan90Charge;
    data['plan_180_charge'] = this.plan180Charge;
    data['plan_365_charge'] = this.plan365Charge;
    data['plan_description'] = this.planDescription;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Logo {
  String? orignalUrl;
  String? dynamicUrl;

  Logo({this.orignalUrl, this.dynamicUrl});

  Logo.fromJson(Map<String, dynamic> json) {
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

class GetUserTransactionModel {
  int? status;
  String? message;
  Data? data;

  GetUserTransactionModel({this.status, this.message, this.data});

  GetUserTransactionModel.fromJson(Map<String, dynamic> json) {
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
  int? totalCount;
  List<Transactionss>? transactions;

  Data({this.totalCount, this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['transactions'] != null) {
      transactions = <Transactionss>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactionss.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
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
      this.store});

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
        ? new OrderTransaction.fromJson(json['order_transaction'])
        : null;
    orderItemRefundTransaction = json['order_item_refund_transaction'] != null
        ? new OrderItemRefundTransaction.fromJson(
            json['order_item_refund_transaction'])
        : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}

class OrderTransaction {
  String? orderTransactionId;
  String? transactionId;
  String? orderId;
  Transaction? transaction;

  OrderTransaction(
      {this.orderTransactionId,
      this.transactionId,
      this.orderId,
      this.transaction});

  OrderTransaction.fromJson(Map<String, dynamic> json) {
    orderTransactionId = json['order_transaction_id'];
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_transaction_id'] = this.orderTransactionId;
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
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
        ? new PaymentService.fromJson(json['payment_service'])
        : null;
    if (json['transaction_histories'] != null) {
      transactionHistories = <TransactionHistories>[];
      json['transaction_histories'].forEach((v) {
        transactionHistories!.add(new TransactionHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
        ? new ReturnOrderItem.fromJson(json['return_order_item'])
        : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
        ? new OrderItem.fromJson(json['order_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_item_id'] = this.orderItemId;
    data['return_items_count'] = this.returnItemsCount;
    data['remarks'] = this.remarks;
    data['total_tax_reversed'] = this.totalTaxReversed;
    data['total_amount_reversed'] = this.totalAmountReversed;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['return_order_item_id'] = this.returnOrderItemId;
    if (this.orderItem != null) {
      data['order_item'] = this.orderItem!.toJson();
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
    data['order_item_status'] = this.orderItemStatus;
    data['cancelledAt'] = this.cancelledAt;
    data['shippedAt'] = this.shippedAt;
    data['deliveredAt'] = this.deliveredAt;
    data['returedAt'] = this.returedAt;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['order_item_id'] = this.orderItemId;
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
        ? new PaymentService.fromJson(json['payment_service'])
        : null;
    if (json['transaction_histories'] != null) {
      transactionHistories = <TransactionHistories>[];
      json['transaction_histories'].forEach((v) {
        transactionHistories!.add(new TransactionHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    image = json['image'] != null ? new Logo.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_name'] = this.storeName;
    data['store_ein'] = this.storeEin;
    data['store_nick_name'] = this.storeNickName;
    data['store_email'] = this.storeEmail;
    data['store_phone'] = this.storePhone;
    data['store_phone_code'] = this.storePhoneCode;
    data['is_verified'] = this.isVerified;
    data['verified_by'] = this.verifiedBy;
    data['is_enabled'] = this.isEnabled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['store_id'] = this.storeId;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orignal_url'] = this.orignalUrl;
    data['dynamic_url'] = this.dynamicUrl;
    return data;
  }
}

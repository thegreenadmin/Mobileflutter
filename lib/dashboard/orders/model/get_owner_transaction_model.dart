// class GetOwnerTransactionModel {
//   int? status;
//   String? message;
//   Data? data;

//   GetOwnerTransactionModel({this.status, this.message, this.data});

//   GetOwnerTransactionModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   dynamic totalCount;
//   List<Transactions>? transactions;

//   Data({this.totalCount, this.transactions});

//   Data.fromJson(Map<String, dynamic> json) {
//     totalCount = json['total_count'];
//     if (json['transactions'] != null) {
//       transactions = <Transactions>[];
//       json['transactions'].forEach((v) {
//         transactions!.add(Transactions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['total_count'] = this.totalCount;
//     if (this.transactions != null) {
//       data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Transactions {
//   String? storeId;
//   String? orderTransactionId;
//   String? orderItemRefundTransactionId;
//   String? storePayoutId;
//   dynamic netBalance;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? storeWalletTransactionId;
//   Store? store;
//   OrderTransaction? orderTransaction;
//   OrderItemRefundTransaction? orderItemRefundTransaction;
//   StorePayout? storePayout;

//   Transactions(
//       {this.storeId,
//       this.orderTransactionId,
//       this.orderItemRefundTransactionId,
//       this.storePayoutId,
//       this.netBalance,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.storeWalletTransactionId,
//       this.store,
//       this.orderTransaction,
//       this.orderItemRefundTransaction,
//       this.storePayout});

//   Transactions.fromJson(Map<String, dynamic> json) {
//     storeId = json['store_id'];
//     orderTransactionId = json['order_transaction_id'];
//     orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
//     storePayoutId = json['store_payout_id'];
//     netBalance = json['net_balance'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     storeWalletTransactionId = json['store_wallet_transaction_id'];
//     store = json['store'] != null ? Store.fromJson(json['store']) : null;
//     orderTransaction = json['order_transaction'] != null
//         ? OrderTransaction.fromJson(json['order_transaction'])
//         : null;
//     orderItemRefundTransaction = json['order_item_refund_transaction'] != null
//         ? OrderItemRefundTransaction.fromJson(
//             json['order_item_refund_transaction'])
//         : null;
//     storePayout = json['store_payout'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['store_id'] = storeId;
//     data['order_transaction_id'] = orderTransactionId;
//     data['order_item_refund_transaction_id'] = orderItemRefundTransactionId;
//     data['store_payout_id'] = storePayoutId;
//     data['net_balance'] = netBalance;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['store_wallet_transaction_id'] = storeWalletTransactionId;
//     if (store != null) {
//       data['store'] = store!.toJson();
//     }
//     if (orderTransaction != null) {
//       data['order_transaction'] = orderTransaction!.toJson();
//     }
//     if (orderItemRefundTransaction != null) {
//       data['order_item_refund_transaction'] =
//           orderItemRefundTransaction!.toJson();
//     }
//     data['store_payout'] = storePayout;
//     return data;
//   }
// }

// class Store {
//   String? storeName;
//   String? storeEin;
//   String? storeNickName;
//   String? storeEmail;
//   String? storePhone;
//   String? storePhoneCode;
//   bool? isVerified;
//   dynamic verifiedBy;
//   bool? isEnabled;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? storeId;
//   Image? image;
//   Image? logo;

//   Store(
//       {this.storeName,
//       this.storeEin,
//       this.storeNickName,
//       this.storeEmail,
//       this.storePhone,
//       this.storePhoneCode,
//       this.isVerified,
//       this.verifiedBy,
//       this.isEnabled,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.storeId,
//       this.image,
//       this.logo});

//   Store.fromJson(Map<String, dynamic> json) {
//     storeName = json['store_name'];
//     storeEin = json['store_ein'];
//     storeNickName = json['store_nick_name'];
//     storeEmail = json['store_email'];
//     storePhone = json['store_phone'];
//     storePhoneCode = json['store_phone_code'];
//     isVerified = json['is_verified'];
//     verifiedBy = json['verified_by'];
//     isEnabled = json['is_enabled'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     storeId = json['store_id'];
//     image = json['image'] != null ? Image.fromJson(json['image']) : null;
//     logo = json['logo'] != null ? Image.fromJson(json['logo']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['store_name'] = storeName;
//     data['store_ein'] = storeEin;
//     data['store_nick_name'] = storeNickName;
//     data['store_email'] = storeEmail;
//     data['store_phone'] = storePhone;
//     data['store_phone_code'] = storePhoneCode;
//     data['is_verified'] = isVerified;
//     data['verified_by'] = verifiedBy;
//     data['is_enabled'] = isEnabled;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['store_id'] = storeId;
//     if (image != null) {
//       data['image'] = image!.toJson();
//     }
//     if (logo != null) {
//       data['logo'] = logo!.toJson();
//     }
//     return data;
//   }
// }

// class Image {
//   String? orignalUrl;
//   String? dynamicUrl;

//   Image({this.orignalUrl, this.dynamicUrl});

//   Image.fromJson(Map<String, dynamic> json) {
//     orignalUrl = json['orignal_url'];
//     dynamicUrl = json['dynamic_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['orignal_url'] = orignalUrl;
//     data['dynamic_url'] = dynamicUrl;
//     return data;
//   }
// }

// class OrderTransaction {
//   String? id;
//   String? transactionId;
//   String? orderId;
//   String? orderTransactionType;
//   String? storeServiceChargeType;
//   double? storeServiceChargeValue;
//   double? storeTotalServiceCharged;
//   String? orderServiceChargeType;
//   double? orderServiceChargeValue;
//   double? orderTotalServiceCharged;
//   double? storeReceivedAmount;
//   double? totalAmount;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? orderTransactionId;
//   Order? order;
//   Transaction? transaction;

//   OrderTransaction(
//       {this.id,
//       this.transactionId,
//       this.orderId,
//       this.orderTransactionType,
//       this.storeServiceChargeType,
//       this.storeServiceChargeValue,
//       this.storeTotalServiceCharged,
//       this.orderServiceChargeType,
//       this.orderServiceChargeValue,
//       this.orderTotalServiceCharged,
//       this.storeReceivedAmount,
//       this.totalAmount,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.orderTransactionId,
//       this.order,
//       this.transaction});

//   OrderTransaction.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     transactionId = json['transaction_id'];
//     orderId = json['order_id'];
//     orderTransactionType = json['order_transaction_type'];
//     storeServiceChargeType = json['store_service_charge_type'];
//     storeServiceChargeValue = json['store_service_charge_value'];
//     storeTotalServiceCharged = json['store_total_service_charged'];
//     orderServiceChargeType = json['order_service_charge_type'];
//     orderServiceChargeValue = json['order_service_charge_value'];
//     orderTotalServiceCharged = json['order_total_service_charged'];
//     storeReceivedAmount = json['store_received_amount'];
//     totalAmount = json['total_amount'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     orderTransactionId = json['order_transaction_id'];
//     order = json['order'] != null ? new Order.fromJson(json['order']) : null;
//     transaction = json['transaction'] != null
//         ? new Transaction.fromJson(json['transaction'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['transaction_id'] = this.transactionId;
//     data['order_id'] = this.orderId;
//     data['order_transaction_type'] = this.orderTransactionType;
//     data['store_service_charge_type'] = this.storeServiceChargeType;
//     data['store_service_charge_value'] = this.storeServiceChargeValue;
//     data['store_total_service_charged'] = this.storeTotalServiceCharged;
//     data['order_service_charge_type'] = this.orderServiceChargeType;
//     data['order_service_charge_value'] = this.orderServiceChargeValue;
//     data['order_total_service_charged'] = this.orderTotalServiceCharged;
//     data['store_received_amount'] = this.storeReceivedAmount;
//     data['total_amount'] = this.totalAmount;
//     data['status'] = this.status;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['order_transaction_id'] = this.orderTransactionId;
//     if (this.order != null) {
//       data['order'] = this.order!.toJson();
//     }
//     if (this.transaction != null) {
//       data['transaction'] = this.transaction!.toJson();
//     }
//     return data;
//   }
// }

// class Order {
//   String? userId;
//   String? storeId;
//   String? deliveryServiceId;
//   dynamic deliveryCharge;
//   String? taxType;
//   dynamic taxValue;
//   dynamic totalTaxCharged;
//   dynamic totalAmount;
//   String? customerName;
//   String? customerEmail;
//   String? customerPhone;
//   String? customerPhoneCode;
//   String? estimateDeliveryDate;
//   String? orderDate;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? orderId;

//   Order(
//       {this.userId,
//       this.storeId,
//       this.deliveryServiceId,
//       this.deliveryCharge,
//       this.taxType,
//       this.taxValue,
//       this.totalTaxCharged,
//       this.totalAmount,
//       this.customerName,
//       this.customerEmail,
//       this.customerPhone,
//       this.customerPhoneCode,
//       this.estimateDeliveryDate,
//       this.orderDate,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.orderId});

//   Order.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     storeId = json['store_id'];
//     deliveryServiceId = json['delivery_service_id'];
//     deliveryCharge = json['delivery_charge'];
//     taxType = json['tax_type'];
//     taxValue = json['tax_value'];
//     totalTaxCharged = json['total_tax_charged'];
//     totalAmount = json['total_amount'];
//     customerName = json['customer_name'];
//     customerEmail = json['customer_email'];
//     customerPhone = json['customer_phone'];
//     customerPhoneCode = json['customer_phone_code'];
//     estimateDeliveryDate = json['estimate_delivery_date'];
//     orderDate = json['order_date'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     orderId = json['order_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user_id'] = userId;
//     data['store_id'] = storeId;
//     data['delivery_service_id'] = deliveryServiceId;
//     data['delivery_charge'] = deliveryCharge;
//     data['tax_type'] = taxType;
//     data['tax_value'] = taxValue;
//     data['total_tax_charged'] = totalTaxCharged;
//     data['total_amount'] = totalAmount;
//     data['customer_name'] = customerName;
//     data['customer_email'] = customerEmail;
//     data['customer_phone'] = customerPhone;
//     data['customer_phone_code'] = customerPhoneCode;
//     data['estimate_delivery_date'] = estimateDeliveryDate;
//     data['order_date'] = orderDate;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['order_id'] = orderId;
//     return data;
//   }
// }

// class Transaction {
//   String? paymentServiceId;
//   String? stripeTransactionId;
//   String? transactionType;
//   dynamic transactionAmount;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? transactionId;

//   Transaction(
//       {this.paymentServiceId,
//       this.stripeTransactionId,
//       this.transactionType,
//       this.transactionAmount,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.transactionId});

//   Transaction.fromJson(Map<String, dynamic> json) {
//     paymentServiceId = json['payment_service_id'];
//     stripeTransactionId = json['stripe_transaction_id'];
//     transactionType = json['transaction_type'];
//     transactionAmount = json['transaction_amount'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     transactionId = json['transaction_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['payment_service_id'] = paymentServiceId;
//     data['stripe_transaction_id'] = stripeTransactionId;
//     data['transaction_type'] = transactionType;
//     data['transaction_amount'] = transactionAmount;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['transaction_id'] = transactionId;
//     return data;
//   }
// }

// class OrderItemRefundTransaction {
//   String? transactionId;
//   String? returnOrderItemId;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? orderItemRefundTransactionId;
//   ReturnOrderItem? returnOrderItem;
//   Transaction? transaction;

//   OrderItemRefundTransaction(
//       {this.transactionId,
//       this.returnOrderItemId,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.orderItemRefundTransactionId,
//       this.returnOrderItem,
//       this.transaction});

//   OrderItemRefundTransaction.fromJson(Map<String, dynamic> json) {
//     transactionId = json['transaction_id'];
//     returnOrderItemId = json['return_order_item_id'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
//     returnOrderItem = json['return_order_item'] != null
//         ? ReturnOrderItem.fromJson(json['return_order_item'])
//         : null;
//     transaction = json['transaction'] != null
//         ? Transaction.fromJson(json['transaction'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['transaction_id'] = transactionId;
//     data['return_order_item_id'] = returnOrderItemId;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['order_item_refund_transaction_id'] = orderItemRefundTransactionId;
//     if (returnOrderItem != null) {
//       data['return_order_item'] = returnOrderItem!.toJson();
//     }
//     if (transaction != null) {
//       data['transaction'] = transaction!.toJson();
//     }
//     return data;
//   }
// }

// class ReturnOrderItem {
//   String? orderItemId;
//   String? remarks;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? returnItemId;

//   ReturnOrderItem(
//       {this.orderItemId,
//       this.remarks,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.returnItemId});

//   ReturnOrderItem.fromJson(Map<String, dynamic> json) {
//     orderItemId = json['order_item_id'];
//     remarks = json['remarks'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     returnItemId = json['return_item_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['order_item_id'] = orderItemId;
//     data['remarks'] = remarks;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['return_item_id'] = returnItemId;
//     return data;
//   }
// }

// class StorePayout {
//   String? transactionId;
//   String? userStripeBankId;
//   int? transferedAmount;
//   int? totalTransactionAmount;
//   int? reversedAmount;
//   int? totalReversedAmount;
//   String? payoutType;
//   Null? isReversed;
//   String? stripeTransferId;
//   String? stripePayoutId;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? storePayoutId;

//   StorePayout(
//       {this.transactionId,
//       this.userStripeBankId,
//       this.transferedAmount,
//       this.totalTransactionAmount,
//       this.reversedAmount,
//       this.totalReversedAmount,
//       this.payoutType,
//       this.isReversed,
//       this.stripeTransferId,
//       this.stripePayoutId,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.storePayoutId});

//   StorePayout.fromJson(Map<String, dynamic> json) {
//     transactionId = json['transaction_id'];
//     userStripeBankId = json['user_stripe_bank_id'];
//     transferedAmount = json['transfered_amount'];
//     totalTransactionAmount = json['total_transaction_amount'];
//     reversedAmount = json['reversed_amount'];
//     totalReversedAmount = json['total_reversed_amount'];
//     payoutType = json['payout_type'];
//     isReversed = json['is_reversed'];
//     stripeTransferId = json['stripe_transfer_id'];
//     stripePayoutId = json['stripe_payout_id'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     storePayoutId = json['store_payout_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['transaction_id'] = this.transactionId;
//     data['user_stripe_bank_id'] = this.userStripeBankId;
//     data['transfered_amount'] = this.transferedAmount;
//     data['total_transaction_amount'] = this.totalTransactionAmount;
//     data['reversed_amount'] = this.reversedAmount;
//     data['total_reversed_amount'] = this.totalReversedAmount;
//     data['payout_type'] = this.payoutType;
//     data['is_reversed'] = this.isReversed;
//     data['stripe_transfer_id'] = this.stripeTransferId;
//     data['stripe_payout_id'] = this.stripePayoutId;
//     data['status'] = this.status;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['store_payout_id'] = this.storePayoutId;
//     return data;
//   }
// }
class GetOwnerTransactionModel {
  int? status;
  String? message;
  Data? data;

  GetOwnerTransactionModel({this.status, this.message, this.data});

  GetOwnerTransactionModel.fromJson(Map<String, dynamic> json) {
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
  List<Transactions>? transactions;

  Data({this.totalCount, this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
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
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    orderTransaction = json['order_transaction'] != null
        ? new OrderTransaction.fromJson(json['order_transaction'])
        : null;
    orderItemRefundTransaction = json['order_item_refund_transaction'] != null
        ? new OrderItemRefundTransaction.fromJson(
            json['order_item_refund_transaction'])
        : null;
    storePayout = json['store_payout'] != null
        ? new StorePayout.fromJson(json['store_payout'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['order_transaction_id'] = this.orderTransactionId;
    data['order_item_refund_transaction_id'] =
        this.orderItemRefundTransactionId;
    data['store_payout_id'] = this.storePayoutId;
    data['net_balance'] = this.netBalance;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['store_wallet_transaction_id'] = this.storeWalletTransactionId;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.orderTransaction != null) {
      data['order_transaction'] = this.orderTransaction!.toJson();
    }
    if (this.orderItemRefundTransaction != null) {
      data['order_item_refund_transaction'] =
          this.orderItemRefundTransaction!.toJson();
    }
    if (this.storePayout != null) {
      data['store_payout'] = this.storePayout!.toJson();
    }
    return data;
  }
}

class Store {
  String? dynamicLink;
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
  Image? image;
  Image? logo;

  Store(
      {this.dynamicLink,
      this.storeName,
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
    dynamicLink = json['dynamic_link'];
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
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    logo = json['logo'] != null ? new Image.fromJson(json['logo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dynamic_link'] = this.dynamicLink;
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
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['order_transaction_id'] = this.orderTransactionId;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Order {
  String? userId;
  String? storeId;
  String? deliveryServiceId;
  double? deliveryCharge;
  String? taxType;
  double? taxValue;
  double? totalTaxCharged;
  String? serviceChargeType;
  double? serviceChargeValue;
  double? totalServiceCharged;
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

  Order(
      {this.userId,
      this.storeId,
      this.deliveryServiceId,
      this.deliveryCharge,
      this.taxType,
      this.taxValue,
      this.totalTaxCharged,
      this.serviceChargeType,
      this.serviceChargeValue,
      this.totalServiceCharged,
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
    serviceChargeType = json['service_charge_type'];
    serviceChargeValue = json['service_charge_value'];
    totalServiceCharged = json['total_service_charged'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['delivery_service_id'] = this.deliveryServiceId;
    data['delivery_charge'] = this.deliveryCharge;
    data['tax_type'] = this.taxType;
    data['tax_value'] = this.taxValue;
    data['total_tax_charged'] = this.totalTaxCharged;
    data['service_charge_type'] = this.serviceChargeType;
    data['service_charge_value'] = this.serviceChargeValue;
    data['total_service_charged'] = this.totalServiceCharged;
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
    return data;
  }
}

class Transaction {
  String? paymentServiceId;
  String? stripePayoutTransactionId;
  String? transactionType;
  double? transactionAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? transactionId;

  Transaction(
      {this.paymentServiceId,
      this.stripePayoutTransactionId,
      this.transactionType,
      this.transactionAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.transactionId});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentServiceId = json['payment_service_id'];
    stripePayoutTransactionId = json['stripe_payout_transaction_id'];
    transactionType = json['transaction_type'];
    transactionAmount = json['transaction_amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_service_id'] = this.paymentServiceId;
    data['stripe_payout_transaction_id'] = this.stripePayoutTransactionId;
    data['transaction_type'] = this.transactionType;
    data['transaction_amount'] = this.transactionAmount;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['transaction_id'] = this.transactionId;
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

  OrderItemRefundTransaction(
      {this.transactionId,
      this.orderItemId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.orderItemRefundTransactionId,
      this.orderItem,
      this.transaction});

  OrderItemRefundTransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderItemId = json['order_item_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderItemRefundTransactionId = json['order_item_refund_transaction_id'];
    orderItem = json['order_item'] != null
        ? new OrderItem.fromJson(json['order_item'])
        : null;
    transaction = json['transaction'] != null
        ? new Transactionn.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['order_item_id'] = this.orderItemId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['order_item_refund_transaction_id'] =
        this.orderItemRefundTransactionId;
    if (this.orderItem != null) {
      data['order_item'] = this.orderItem!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class OrderItem {
  String? orderId;
  String? productId;
  int? orderItemCount;
  double? orderItemPrice;
  String? discountName;
  String? discountType;
  int? discountValue;
  int? totalDiscount;
  String? orderItemStatus;
  Null? cancelledAt;
  Null? shippedAt;
  Null? deliveredAt;
  Null? returedAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? orderItemId;

  OrderItem(
      {this.orderId,
      this.productId,
      this.orderItemCount,
      this.orderItemPrice,
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

class Transactionn {
  String? paymentServiceId;
  String? transactionType;
  double? transactionAmount;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_service_id'] = this.paymentServiceId;
    data['transaction_type'] = this.transactionType;
    data['transaction_amount'] = this.transactionAmount;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}

class StorePayout {
  String? transactionId;
  String? userStripeBankId;
  int? transferedAmount;
  int? totalTransactionAmount;
  int? reversedAmount;
  int? totalReversedAmount;
  String? payoutType;
  Null? isReversed;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['user_stripe_bank_id'] = this.userStripeBankId;
    data['transfered_amount'] = this.transferedAmount;
    data['total_transaction_amount'] = this.totalTransactionAmount;
    data['reversed_amount'] = this.reversedAmount;
    data['total_reversed_amount'] = this.totalReversedAmount;
    data['payout_type'] = this.payoutType;
    data['is_reversed'] = this.isReversed;
    data['stripe_transfer_id'] = this.stripeTransferId;
    data['stripe_payout_id'] = this.stripePayoutId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['store_payout_id'] = this.storePayoutId;
    return data;
  }
}

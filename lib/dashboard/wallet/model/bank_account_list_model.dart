class BankAccountListModel {
  int? status;
  String? message;
  Data? data;

  BankAccountListModel({this.status, this.message, this.data});

  BankAccountListModel.fromJson(Map<String, dynamic> json) {
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
  List<Banks>? banks;

  Data({this.banks});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banks'] != null) {
      banks = <Banks>[];
      json['banks'].forEach((v) {
        banks!.add(Banks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banks != null) {
      data['banks'] = banks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banks {
  String? userStripeId;
  String? stripeBankId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userStripeBankId;
  Bank? bank;

  Banks(
      {this.userStripeId,
      this.stripeBankId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userStripeBankId,
      this.bank});

  Banks.fromJson(Map<String, dynamic> json) {
    userStripeId = json['user_stripe_id'];
    stripeBankId = json['stripe_bank_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userStripeBankId = json['user_stripe_bank_id'];
    bank = json['bank'] != null ? Bank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_stripe_id'] = userStripeId;
    data['stripe_bank_id'] = stripeBankId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user_stripe_bank_id'] = userStripeBankId;
    if (bank != null) {
      data['bank'] = bank!.toJson();
    }
    return data;
  }
}

class Bank {
  String? id;
  String? object;
  String? accountHolderName;
  String? accountHolderType;
  dynamic accountType;
  String? bankName;
  String? country;
  String? currency;
  String? customer;
  String? fingerprint;
  String? last4;
  Metadata? metadata;
  String? routingNumber;
  String? status;

  Bank(
      {this.id,
      this.object,
      this.accountHolderName,
      this.accountHolderType,
      this.accountType,
      this.bankName,
      this.country,
      this.currency,
      this.customer,
      this.fingerprint,
      this.last4,
      this.metadata,
      this.routingNumber,
      this.status});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    accountHolderName = json['account_holder_name'];
    accountHolderType = json['account_holder_type'];
    accountType = json['account_type'];
    bankName = json['bank_name'];
    country = json['country'];
    currency = json['currency'];
    customer = json['customer'];
    fingerprint = json['fingerprint'];
    last4 = json['last4'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    routingNumber = json['routing_number'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['account_holder_name'] = accountHolderName;
    data['account_holder_type'] = accountHolderType;
    data['account_type'] = accountType;
    data['bank_name'] = bankName;
    data['country'] = country;
    data['currency'] = currency;
    data['customer'] = customer;
    data['fingerprint'] = fingerprint;
    data['last4'] = last4;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['routing_number'] = routingNumber;
    data['status'] = status;
    return data;
  }
}

class Metadata {
  String? nODEENV;
  String? userId;

  Metadata({this.nODEENV, this.userId});

  Metadata.fromJson(Map<String, dynamic> json) {
    nODEENV = json['NODE_ENV'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NODE_ENV'] = nODEENV;
    data['user_id'] = userId;
    return data;
  }
}

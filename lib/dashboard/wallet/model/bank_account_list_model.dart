// class BankAccountListModel {
//   int? status;
//   String? message;
//   Data? data;

//   BankAccountListModel({this.status, this.message, this.data});

//   BankAccountListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   List<Banks>? banks;

//   Data({this.banks});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['banks'] != null) {
//       banks = <Banks>[];
//       json['banks'].forEach((v) {
//         banks!.add(new Banks.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.banks != null) {
//       data['banks'] = this.banks!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Banks {
//   String? userStripeId;
//   String? stripeBankId;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? userStripeBankId;
//   Card? card;

//   Banks(
//       {this.userStripeId,
//       this.stripeBankId,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.userStripeBankId,
//       this.card});

//   Banks.fromJson(Map<String, dynamic> json) {
//     userStripeId = json['user_stripe_id'];
//     stripeBankId = json['stripe_bank_id'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     userStripeBankId = json['user_stripe_bank_id'];
//     card = json['card'] != null ? new Card.fromJson(json['card']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_stripe_id'] = this.userStripeId;
//     data['stripe_bank_id'] = this.stripeBankId;
//     data['status'] = this.status;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['user_stripe_bank_id'] = this.userStripeBankId;
//     if (this.card != null) {
//       data['card'] = this.card!.toJson();
//     }
//     return data;
//   }
// }

// class Card {
//   String? id;
//   String? object;
//   String? accountHolderName;
//   String? accountHolderType;
//   Null? accountType;
//   String? bankName;
//   String? country;
//   String? currency;
//   String? customer;
//   String? fingerprint;
//   String? last4;
//   Metadata? metadata;
//   String? routingNumber;
//   String? status;

//   Card(
//       {this.id,
//       this.object,
//       this.accountHolderName,
//       this.accountHolderType,
//       this.accountType,
//       this.bankName,
//       this.country,
//       this.currency,
//       this.customer,
//       this.fingerprint,
//       this.last4,
//       this.metadata,
//       this.routingNumber,
//       this.status});

//   Card.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     object = json['object'];
//     accountHolderName = json['account_holder_name'];
//     accountHolderType = json['account_holder_type'];
//     accountType = json['account_type'];
//     bankName = json['bank_name'];
//     country = json['country'];
//     currency = json['currency'];
//     customer = json['customer'];
//     fingerprint = json['fingerprint'];
//     last4 = json['last4'];
//     metadata = json['metadata'] != null
//         ? new Metadata.fromJson(json['metadata'])
//         : null;
//     routingNumber = json['routing_number'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['object'] = this.object;
//     data['account_holder_name'] = this.accountHolderName;
//     data['account_holder_type'] = this.accountHolderType;
//     data['account_type'] = this.accountType;
//     data['bank_name'] = this.bankName;
//     data['country'] = this.country;
//     data['currency'] = this.currency;
//     data['customer'] = this.customer;
//     data['fingerprint'] = this.fingerprint;
//     data['last4'] = this.last4;
//     if (this.metadata != null) {
//       data['metadata'] = this.metadata!.toJson();
//     }
//     data['routing_number'] = this.routingNumber;
//     data['status'] = this.status;
//     return data;
//   }
// }

// class Metadata {
//   String? nODEENV;
//   String? userId;

//   Metadata({this.nODEENV, this.userId});

//   Metadata.fromJson(Map<String, dynamic> json) {
//     nODEENV = json['NODE_ENV'];
//     userId = json['user_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['NODE_ENV'] = this.nODEENV;
//     data['user_id'] = this.userId;
//     return data;
//   }
// }
class BankAccountListModel {
  int? status;
  String? message;
  Data? data;

  BankAccountListModel({this.status, this.message, this.data});

  BankAccountListModel.fromJson(Map<String, dynamic> json) {
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
  List<Banks>? banks;

  Data({this.banks});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banks'] != null) {
      banks = <Banks>[];
      json['banks'].forEach((v) {
        banks!.add(new Banks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banks != null) {
      data['banks'] = this.banks!.map((v) => v.toJson()).toList();
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
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_stripe_id'] = this.userStripeId;
    data['stripe_bank_id'] = this.stripeBankId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_stripe_bank_id'] = this.userStripeBankId;
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    return data;
  }
}

class Bank {
  String? id;
  String? object;
  String? accountHolderName;
  String? accountHolderType;
  Null? accountType;
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
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    routingNumber = json['routing_number'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['account_holder_name'] = this.accountHolderName;
    data['account_holder_type'] = this.accountHolderType;
    data['account_type'] = this.accountType;
    data['bank_name'] = this.bankName;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['customer'] = this.customer;
    data['fingerprint'] = this.fingerprint;
    data['last4'] = this.last4;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['routing_number'] = this.routingNumber;
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NODE_ENV'] = this.nODEENV;
    data['user_id'] = this.userId;
    return data;
  }
}

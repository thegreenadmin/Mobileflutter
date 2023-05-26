class GetAutoRechargeModel {
  int? status;
  String? message;
  Data? data;

  GetAutoRechargeModel({this.status, this.message, this.data});

  GetAutoRechargeModel.fromJson(Map<String, dynamic> json) {
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
  UserWalletAutoCharge? userWalletAutoCharge;

  Data({this.userWalletAutoCharge});

  Data.fromJson(Map<String, dynamic> json) {
    userWalletAutoCharge = json['user_wallet_auto_charge'] != null
        ? new UserWalletAutoCharge.fromJson(json['user_wallet_auto_charge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userWalletAutoCharge != null) {
      data['user_wallet_auto_charge'] = this.userWalletAutoCharge!.toJson();
    }
    return data;
  }
}

class UserWalletAutoCharge {
  String? userId;
  String? userStripeCardId;
  String? autoChargeType;
  int? thresholdAmount;
  int? chargeAmount;
  String? startDate;
  String? endDate;
  int? frequency;
  String? status;
  int? day;
  String? createdAt;
  String? updatedAt;
  String? userWalletAutoChargeId;

  UserWalletAutoCharge(
      {this.userId,
      this.userStripeCardId,
      this.autoChargeType,
      this.thresholdAmount,
      this.chargeAmount,
      this.startDate,
      this.endDate,
      this.frequency,
      this.status,
      this.day,
      this.createdAt,
      this.updatedAt,
      this.userWalletAutoChargeId});

  UserWalletAutoCharge.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userStripeCardId = json['user_stripe_card_id'];
    autoChargeType = json['auto_charge_type'];
    thresholdAmount = json['threshold_amount'];
    chargeAmount = json['charge_amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    frequency = json['frequency'];
    status = json['status'];
    day = json['day'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userWalletAutoChargeId = json['user_wallet_auto_charge_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_stripe_card_id'] = this.userStripeCardId;
    data['auto_charge_type'] = this.autoChargeType;
    data['threshold_amount'] = this.thresholdAmount;
    data['charge_amount'] = this.chargeAmount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['frequency'] = this.frequency;
    data['status'] = this.status;
    data['day'] = this.day;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_wallet_auto_charge_id'] = this.userWalletAutoChargeId;
    return data;
  }
}

class GetAutoRechargeModel {
  dynamic status;
  String? message;
  Data? data;

  GetAutoRechargeModel({this.status, this.message, this.data});

  GetAutoRechargeModel.fromJson(Map<String, dynamic> json) {
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
  UserWalletAutoCharge? userWalletAutoCharge;

  Data({this.userWalletAutoCharge});

  Data.fromJson(Map<String, dynamic> json) {
    userWalletAutoCharge = json['user_wallet_auto_charge'] != null
        ? UserWalletAutoCharge.fromJson(json['user_wallet_auto_charge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userWalletAutoCharge != null) {
      data['user_wallet_auto_charge'] = userWalletAutoCharge!.toJson();
    }
    return data;
  }
}

class UserWalletAutoCharge {
  String? userId;
  String? userStripeCardId;
  String? autoChargeType;
  dynamic thresholdAmount;
  dynamic chargeAmount;
  String? startDate;
  String? endDate;
  dynamic frequency;
  String? status;
  dynamic day;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_stripe_card_id'] = userStripeCardId;
    data['auto_charge_type'] = autoChargeType;
    data['threshold_amount'] = thresholdAmount;
    data['charge_amount'] = chargeAmount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['frequency'] = frequency;
    data['status'] = status;
    data['day'] = day;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user_wallet_auto_charge_id'] = userWalletAutoChargeId;
    return data;
  }
}

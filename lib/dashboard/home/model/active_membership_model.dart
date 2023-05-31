class ActiveMembershipPlanModel {
  int? status;
  String? message;
  Data? data;

  ActiveMembershipPlanModel({this.status, this.message, this.data});

  ActiveMembershipPlanModel.fromJson(Map<String, dynamic> json) {
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
  int? totalCount;
  List<ActiveMemberships>? memberships;

  Data({this.totalCount, this.memberships});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['memberships'] != null) {
      memberships = <ActiveMemberships>[];
      json['memberships'].forEach((v) {
        memberships!.add(ActiveMemberships.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (memberships != null) {
      data['memberships'] = memberships!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActiveMemberships {
  String? userId;
  String? membershipPlanId;
  String? transactionId;
  int? membershipCharge;
  int? duration;
  String? expiredAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? paymentServiceId;
  String? membershipId;
  MembershipPlan? membershipPlan;

  ActiveMemberships(
      {this.userId,
      this.membershipPlanId,
      this.transactionId,
      this.membershipCharge,
      this.duration,
      this.expiredAt,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.paymentServiceId,
      this.membershipId,
      this.membershipPlan});

  ActiveMemberships.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    membershipPlanId = json['membership_plan_id'];
    transactionId = json['transaction_id'];
    membershipCharge = json['membership_charge'];
    duration = json['duration'];
    expiredAt = json['expiredAt'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    paymentServiceId = json['payment_service_id'];
    membershipId = json['membership_id'];
    membershipPlan = json['membership_plan'] != null
        ? MembershipPlan.fromJson(json['membership_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['membership_plan_id'] = membershipPlanId;
    data['transaction_id'] = transactionId;
    data['membership_charge'] = membershipCharge;
    data['duration'] = duration;
    data['expiredAt'] = expiredAt;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['payment_service_id'] = paymentServiceId;
    data['membership_id'] = membershipId;
    if (membershipPlan != null) {
      data['membership_plan'] = membershipPlan!.toJson();
    }
    return data;
  }
}

class MembershipPlan {
  String? planType;
  int? planDays;
  int? planCharge;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? membershipPlanId;

  MembershipPlan(
      {this.planType,
      this.planDays,
      this.planCharge,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.membershipPlanId});

  MembershipPlan.fromJson(Map<String, dynamic> json) {
    planType = json['plan_type'];
    planDays = json['plan_days'];
    planCharge = json['plan_charge'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    membershipPlanId = json['membership_plan_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plan_type'] = planType;
    data['plan_days'] = planDays;
    data['plan_charge'] = planCharge;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['membership_plan_id'] = membershipPlanId;
    return data;
  }
}

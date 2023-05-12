class ActiveMembershipPlanModel {
  int? status;
  String? message;
  Data? data;

  ActiveMembershipPlanModel({this.status, this.message, this.data});

  ActiveMembershipPlanModel.fromJson(Map<String, dynamic> json) {
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
  List<ActiveMemberships>? memberships;

  Data({this.totalCount, this.memberships});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['memberships'] != null) {
      memberships = <ActiveMemberships>[];
      json['memberships'].forEach((v) {
        memberships!.add(new ActiveMemberships.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.memberships != null) {
      data['memberships'] = this.memberships!.map((v) => v.toJson()).toList();
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
        ? new MembershipPlan.fromJson(json['membership_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['membership_plan_id'] = this.membershipPlanId;
    data['transaction_id'] = this.transactionId;
    data['membership_charge'] = this.membershipCharge;
    data['duration'] = this.duration;
    data['expiredAt'] = this.expiredAt;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['payment_service_id'] = this.paymentServiceId;
    data['membership_id'] = this.membershipId;
    if (this.membershipPlan != null) {
      data['membership_plan'] = this.membershipPlan!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_type'] = this.planType;
    data['plan_days'] = this.planDays;
    data['plan_charge'] = this.planCharge;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['membership_plan_id'] = this.membershipPlanId;
    return data;
  }
}

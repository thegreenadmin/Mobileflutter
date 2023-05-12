class MembershipPlanModel {
  int? status;
  String? message;
  Data? data;

  MembershipPlanModel({this.status, this.message, this.data});

  MembershipPlanModel.fromJson(Map<String, dynamic> json) {
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
  List<MembershipPlans>? membershipPlans;

  Data({this.membershipPlans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['membership_plans'] != null) {
      membershipPlans = <MembershipPlans>[];
      json['membership_plans'].forEach((v) {
        membershipPlans!.add(new MembershipPlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.membershipPlans != null) {
      data['membership_plans'] =
          this.membershipPlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MembershipPlans {
  String? planType;
  int? planDays;
  int? planCharge;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? membershipPlanId;

  MembershipPlans(
      {this.planType,
      this.planDays,
      this.planCharge,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.membershipPlanId});

  MembershipPlans.fromJson(Map<String, dynamic> json) {
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

// To parse this JSON data, do
//
//     final activeMembershipPlanModel = activeMembershipPlanModelFromJson(jsonString);

import 'dart:convert';

ActiveMembershipPlanModel activeMembershipPlanModelFromJson(String str) =>
    ActiveMembershipPlanModel.fromJson(json.decode(str));

String activeMembershipPlanModelToJson(ActiveMembershipPlanModel data) =>
    json.encode(data.toJson());

class ActiveMembershipPlanModel {
  int? status;
  String? message;
  ActiveMembershipData? data;

  ActiveMembershipPlanModel({
    this.status,
    this.message,
    this.data,
  });

  ActiveMembershipPlanModel copyWith({
    int? status,
    String? message,
    ActiveMembershipData? data,
  }) =>
      ActiveMembershipPlanModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ActiveMembershipPlanModel.fromJson(Map<String, dynamic> json) =>
      ActiveMembershipPlanModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ActiveMembershipData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ActiveMembershipData {
  int? totalCount;
  List<ActiveMemberships>? memberships;

  ActiveMembershipData({
    this.totalCount,
    this.memberships,
  });

  ActiveMembershipData copyWith({
    int? totalCount,
    List<ActiveMemberships>? memberships,
  }) =>
      ActiveMembershipData(
        totalCount: totalCount ?? this.totalCount,
        memberships: memberships ?? this.memberships,
      );

  factory ActiveMembershipData.fromJson(Map<String, dynamic> json) => ActiveMembershipData(
        totalCount: json["total_count"],
        memberships: json["memberships"] == null
            ? []
            : List<ActiveMemberships>.from(
                json["memberships"]!.map((x) => ActiveMemberships.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "memberships": memberships == null
            ? []
            : List<dynamic>.from(memberships!.map((x) => x.toJson())),
      };
}

class ActiveMemberships {
  String? userId;
  String? membershipPlanId;
  String? transactionId;
  int? membershipCharge;
  int? duration;
  DateTime? expiredAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? membershipId;
  MembershipPlan? membershipPlan;

  ActiveMemberships({
    this.userId,
    this.membershipPlanId,
    this.transactionId,
    this.membershipCharge,
    this.duration,
    this.expiredAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.membershipId,
    this.membershipPlan,
  });

  ActiveMemberships copyWith({
    String? userId,
    String? membershipPlanId,
    String? transactionId,
    int? membershipCharge,
    int? duration,
    DateTime? expiredAt,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? membershipId,
    MembershipPlan? membershipPlan,
  }) =>
      ActiveMemberships(
        userId: userId ?? this.userId,
        membershipPlanId: membershipPlanId ?? this.membershipPlanId,
        transactionId: transactionId ?? this.transactionId,
        membershipCharge: membershipCharge ?? this.membershipCharge,
        duration: duration ?? this.duration,
        expiredAt: expiredAt ?? this.expiredAt,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        membershipId: membershipId ?? this.membershipId,
        membershipPlan: membershipPlan ?? this.membershipPlan,
      );

  factory ActiveMemberships.fromJson(Map<String, dynamic> json) => ActiveMemberships(
        userId: json["user_id"],
        membershipPlanId: json["membership_plan_id"],
        transactionId: json["transaction_id"],
        membershipCharge: json["membership_charge"],
        duration: json["duration"],
        expiredAt: json["expiredAt"] == null
            ? null
            : DateTime.parse(json["expiredAt"]),
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        membershipId: json["membership_id"],
        membershipPlan: json["membership_plan"] == null
            ? null
            : MembershipPlan.fromJson(json["membership_plan"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "membership_plan_id": membershipPlanId,
        "transaction_id": transactionId,
        "membership_charge": membershipCharge,
        "duration": duration,
        "expiredAt": expiredAt?.toIso8601String(),
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "membership_id": membershipId,
        "membership_plan": membershipPlan?.toJson(),
      };
}

class MembershipPlan {
  String? planName;
  String? planType;
  int? plan30Charge;
  int? plan90Charge;
  int? plan180Charge;
  int? plan365Charge;
  String? planDescription;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? membershipPlanId;

  MembershipPlan({
    this.planName,
    this.planType,
    this.plan30Charge,
    this.plan90Charge,
    this.plan180Charge,
    this.plan365Charge,
    this.planDescription,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.membershipPlanId,
  });

  MembershipPlan copyWith({
    String? planName,
    String? planType,
    int? plan30Charge,
    int? plan90Charge,
    int? plan180Charge,
    int? plan365Charge,
    String? planDescription,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? membershipPlanId,
  }) =>
      MembershipPlan(
        planName: planName ?? this.planName,
        planType: planType ?? this.planType,
        plan30Charge: plan30Charge ?? this.plan30Charge,
        plan90Charge: plan90Charge ?? this.plan90Charge,
        plan180Charge: plan180Charge ?? this.plan180Charge,
        plan365Charge: plan365Charge ?? this.plan365Charge,
        planDescription: planDescription ?? this.planDescription,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        membershipPlanId: membershipPlanId ?? this.membershipPlanId,
      );

  factory MembershipPlan.fromJson(Map<String, dynamic> json) => MembershipPlan(
        planName: json["plan_name"],
        planType: json["plan_type"],
        plan30Charge: json["plan_30_charge"],
        plan90Charge: json["plan_90_charge"],
        plan180Charge: json["plan_180_charge"],
        plan365Charge: json["plan_365_charge"],
        planDescription: json["plan_description"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        membershipPlanId: json["membership_plan_id"],
      );

  Map<String, dynamic> toJson() => {
        "plan_name": planName,
        "plan_type": planType,
        "plan_30_charge": plan30Charge,
        "plan_90_charge": plan90Charge,
        "plan_180_charge": plan180Charge,
        "plan_365_charge": plan365Charge,
        "plan_description": planDescription,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "membership_plan_id": membershipPlanId,
      };
}

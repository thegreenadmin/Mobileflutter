// To parse this JSON data, do
//
//     final membershipPlanModel = membershipPlanModelFromJson(jsonString);

import 'dart:convert';

MembershipPlanModel membershipPlanModelFromJson(String str) =>
    MembershipPlanModel.fromJson(json.decode(str));

String membershipPlanModelToJson(MembershipPlanModel data) =>
    json.encode(data.toJson());

class MembershipPlanModel {
  int? status;
  String? message;
  MembershipPlanData? data;

  MembershipPlanModel({
    this.status,
    this.message,
    this.data,
  });

  MembershipPlanModel copyWith({
    int? status,
    String? message,
    MembershipPlanData? data,
  }) =>
      MembershipPlanModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) =>
      MembershipPlanModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : MembershipPlanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class MembershipPlanData {
  List<MembershipPlans>? membershipPlans;

  MembershipPlanData({
    this.membershipPlans,
  });

  MembershipPlanData copyWith({
    List<MembershipPlans>? membershipPlans,
  }) =>
      MembershipPlanData(
        membershipPlans: membershipPlans ?? this.membershipPlans,
      );

  factory MembershipPlanData.fromJson(Map<String, dynamic> json) =>
      MembershipPlanData(
        membershipPlans: json["membership_plans"] == null
            ? []
            : List<MembershipPlans>.from(json["membership_plans"]!
                .map((x) => MembershipPlans.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "membership_plans": membershipPlans == null
            ? []
            : List<dynamic>.from(membershipPlans!.map((x) => x.toJson())),
      };
}

class MembershipPlans {
  String? planName;
  String? planType;
  String? selectedPlan;
  int? plan30Charge;
  int? plan90Charge;
  int? plan180Charge;
  int? plan365Charge;
  String? planDescription;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? membershipPlanId;

  MembershipPlans({
    this.planName,
    this.planType,
    this.selectedPlan = "",
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

  MembershipPlans copyWith({
    String? planName,
    String? planType,
    String? selectedPlan,
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
      MembershipPlans(
        planName: planName ?? this.planName,
        planType: planType ?? this.planType,
        selectedPlan: selectedPlan ?? this.selectedPlan,
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

  factory MembershipPlans.fromJson(Map<String, dynamic> json) =>
      MembershipPlans(
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

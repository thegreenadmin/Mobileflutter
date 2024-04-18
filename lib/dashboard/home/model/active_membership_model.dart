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
        data: json["data"] == null
            ? null
            : ActiveMembershipData.fromJson(json["data"]),
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

  factory ActiveMembershipData.fromJson(Map<String, dynamic> json) =>
      ActiveMembershipData(
        totalCount: json["total_count"],
        memberships: json["membersips"] == null
            ? []
            : List<ActiveMemberships>.from(
                json["membersips"]!.map((x) => ActiveMemberships.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "membersips": memberships == null
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
  MembershipStore? membershipStore;

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
    this.membershipStore,
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
    MembershipStore? membershipStore,
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
        membershipStore: membershipStore ?? this.membershipStore,
      );

  factory ActiveMemberships.fromJson(Map<String, dynamic> json) =>
      ActiveMemberships(
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
            : MembershipPlan.fromJson(
                json["membership_plan"],
              ),
        membershipStore: json["store"] == null
            ? null
            : MembershipStore.fromJson(json["store"]),
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
        "store": membershipStore?.toJson(),
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
  String? id;

  MembershipPlan({
    this.id,
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
    String? id,
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
        id: id ?? this.id,
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
        id: json["id"],
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
        "id": id,
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

class MembershipStore {
  dynamic storeBalance;
  dynamic taxValue;
  dynamic dynamicLink;
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
  DateTime? createdAt;
  DateTime? updatedAt;
  String? storeId;
  //Image? imageBanner;
  //Image? logo;

  MembershipStore({
    this.storeBalance,
    this.taxValue,
    this.dynamicLink,
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
    // this.imageBanner,
    //this.logo,
  });

  MembershipStore copyWith({
    int? storeBalance,
    int? taxValue,
    dynamic dynamicLink,
    String? storeName,
    String? storeEin,
    String? storeNickName,
    String? storeEmail,
    String? storePhone,
    String? storePhoneCode,
    bool? isVerified,
    String? verifiedBy,
    bool? isEnabled,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? storeId,
    // Image? imageBanner,
    // Image? logo,
  }) =>
      MembershipStore(
        storeBalance: storeBalance ?? this.storeBalance,
        taxValue: taxValue ?? this.taxValue,
        dynamicLink: dynamicLink ?? this.dynamicLink,
        storeName: storeName ?? this.storeName,
        storeEin: storeEin ?? this.storeEin,
        storeNickName: storeNickName ?? this.storeNickName,
        storeEmail: storeEmail ?? this.storeEmail,
        storePhone: storePhone ?? this.storePhone,
        storePhoneCode: storePhoneCode ?? this.storePhoneCode,
        isVerified: isVerified ?? this.isVerified,
        verifiedBy: verifiedBy ?? this.verifiedBy,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        storeId: storeId ?? this.storeId,
        //imageBanner: imageBanner ?? this.imageBanner,
        //logo: logo ?? this.logo,
      );

  factory MembershipStore.fromJson(Map<String, dynamic> json) =>
      MembershipStore(
        storeBalance: json["store_balance"],
        taxValue: json["tax_value"],
        dynamicLink: json["dynamic_link"],
        storeName: json["store_name"],
        storeEin: json["store_ein"],
        storeNickName: json["store_nick_name"],
        storeEmail: json["store_email"],
        storePhone: json["store_phone"],
        storePhoneCode: json["store_phone_code"],
        isVerified: json["is_verified"],
        verifiedBy: json["verified_by"],
        isEnabled: json["is_enabled"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        storeId: json["store_id"],
        // imageBanner:
        // json["image"] == null ? null : Image.fromJson(json["image"]),
        // logo: json["logo"] == null ? null : Image.fromJson(json["logo"]),
      );

  Map<String, dynamic> toJson() => {
        "store_balance": storeBalance,
        "tax_value": taxValue,
        "dynamic_link": dynamicLink,
        "store_name": storeName,
        "store_ein": storeEin,
        "store_nick_name": storeNickName,
        "store_email": storeEmail,
        "store_phone": storePhone,
        "store_phone_code": storePhoneCode,
        "is_verified": isVerified,
        "verified_by": verifiedBy,
        "is_enabled": isEnabled,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "store_id": storeId,
        //"image": imageBanner?.toJson(),
        //"logo": logo?.toJson(),
      };
}

// class Image {
//   String? orignalUrl;
//   String? dynamicUrl;

//   Image({
//     this.orignalUrl,
//     this.dynamicUrl,
//   });

//   Image copyWith({
//     String? orignalUrl,
//     String? dynamicUrl,
//   }) =>
//       Image(
//         orignalUrl: orignalUrl ?? this.orignalUrl,
//         dynamicUrl: dynamicUrl ?? this.dynamicUrl,
//       );

//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         orignalUrl: json["orignal_url"],
//         dynamicUrl: json["dynamic_url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "orignal_url": orignalUrl,
//         "dynamic_url": dynamicUrl,
//       };
// }

// To parse this JSON data, do
//
//     final workerListResponse = workerListResponseFromJson(jsonString);

import 'dart:convert';

WorkerListResponse workerListResponseFromJson(String str) =>
    WorkerListResponse.fromJson(json.decode(str));

String workerListResponseToJson(WorkerListResponse data) =>
    json.encode(data.toJson());

class WorkerListResponse {
  WorkerListResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  WorkerListResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      WorkerListResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory WorkerListResponse.fromJson(Map<String, dynamic> json) =>
      WorkerListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.totalCount,
    this.storeUsers,
  });

  int? totalCount;
  List<StoreUser>? storeUsers;

  Data copyWith({
    int? totalCount,
    List<StoreUser>? storeUsers,
  }) =>
      Data(
        totalCount: totalCount ?? this.totalCount,
        storeUsers: storeUsers ?? this.storeUsers,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCount: json["total_count"],
        storeUsers: json["store_users"] == null
            ? []
            : List<StoreUser>.from(
                json["store_users"]!.map((x) => StoreUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "store_users": storeUsers == null
            ? []
            : List<dynamic>.from(storeUsers!.map((x) => x.toJson())),
      };
}

class StoreUser {
  StoreUser({
    this.storeUserId,
    this.isStoreOwner,
    this.isVerified,
    this.verifiedAt,
    this.user,
    this.role,
    this.storeUserTimings,
  });

  String? storeUserId;
  bool? isStoreOwner;
  bool? isVerified;
  DateTime? verifiedAt;
  User? user;
  dynamic role;
  List<StoreUserTiming>? storeUserTimings;

  StoreUser copyWith({
    String? storeUserId,
    bool? isStoreOwner,
    bool? isVerified,
    DateTime? verifiedAt,
    User? user,
    String? role,
    List<StoreUserTiming>? storeUserTimings,
  }) =>
      StoreUser(
        storeUserId: storeUserId ?? this.storeUserId,
        isStoreOwner: isStoreOwner ?? this.isStoreOwner,
        isVerified: isVerified ?? this.isVerified,
        verifiedAt: verifiedAt ?? this.verifiedAt,
        user: user ?? this.user,
        role: role ?? this.role,
        storeUserTimings: storeUserTimings ?? this.storeUserTimings,
      );

  factory StoreUser.fromJson(Map<String, dynamic> json) => StoreUser(
        storeUserId: json["store_user_id"],
        isStoreOwner: json["is_store_owner"],
        isVerified: json["is_verified"],
        verifiedAt: json["verifiedAt"] == null
            ? null
            : DateTime.parse(json["verifiedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        role: json["role"],
        storeUserTimings: json["store_user_timings"] == null
            ? []
            : List<StoreUserTiming>.from(json["store_user_timings"]!
                .map((x) => StoreUserTiming.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_user_id": storeUserId,
        "is_store_owner": isStoreOwner,
        "is_verified": isVerified,
        "verifiedAt": verifiedAt?.toIso8601String(),
        "user": user?.toJson(),
        "role": role,
        "store_user_timings": storeUserTimings == null
            ? []
            : List<dynamic>.from(storeUserTimings!.map((x) => x.toJson())),
      };
}

class StoreUserTiming {
  StoreUserTiming({
    this.storeUserTimingId,
    this.dayOfWeek,
    this.is24HrsActive,
    this.startTime,
    this.endTime,
    this.status,
  });

  String? storeUserTimingId;
  int? dayOfWeek;
  bool? is24HrsActive;
  String? startTime;
  String? endTime;
  String? status;

  StoreUserTiming copyWith({
    String? storeUserTimingId,
    int? dayOfWeek,
    bool? is24HrsActive,
    String? startTime,
    String? endTime,
    String? status,
  }) =>
      StoreUserTiming(
        storeUserTimingId: storeUserTimingId ?? this.storeUserTimingId,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        is24HrsActive: is24HrsActive ?? this.is24HrsActive,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
      );

  factory StoreUserTiming.fromJson(Map<String, dynamic> json) =>
      StoreUserTiming(
        storeUserTimingId: json["store_user_timing_id"],
        dayOfWeek: json["day_of_week"],
        is24HrsActive: json["is_24_hrs_active"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "store_user_timing_id": storeUserTimingId,
        "day_of_week": dayOfWeek,
        "is_24_hrs_active": is24HrsActive,
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
      };
}

class User {
  User({
    this.userId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.userAddresses,
    this.image,
  });

  String? userId;
  String? email;
  String? phone;
  String? firstName;
  String? lastName;
  List<UserAddress>? userAddresses;
  Image? image;

  User copyWith({
    String? userId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    List<UserAddress>? userAddresses,
    Image? image,
  }) =>
      User(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        userAddresses: userAddresses ?? this.userAddresses,
        image: image ?? this.image,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userAddresses: json["user_addresses"] == null
            ? []
            : List<UserAddress>.from(
                json["user_addresses"]!.map((x) => UserAddress.fromJson(x))),
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "user_addresses": userAddresses == null
            ? []
            : List<dynamic>.from(userAddresses!.map((x) => x.toJson())),
        "image": image?.toJson(),
      };
}

class Image {
  Image({
    this.orignalUrl,
    this.dynamicUrl,
  });

  String? orignalUrl;
  String? dynamicUrl;

  Image copyWith({
    String? orignalUrl,
    String? dynamicUrl,
  }) =>
      Image(
        orignalUrl: orignalUrl ?? this.orignalUrl,
        dynamicUrl: dynamicUrl ?? this.dynamicUrl,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        orignalUrl: json["orignal_url"],
        dynamicUrl: json["dynamic_url"],
      );

  Map<String, dynamic> toJson() => {
        "orignal_url": orignalUrl,
        "dynamic_url": dynamicUrl,
      };
}

class UserAddress {
  UserAddress({
    this.userAddressId,
    this.addressName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postalCode,
  });

  String? userAddressId;
  String? addressName;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? postalCode;

  UserAddress copyWith({
    String? userAddressId,
    String? addressName,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
  }) =>
      UserAddress(
        userAddressId: userAddressId ?? this.userAddressId,
        addressName: addressName ?? this.addressName,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
      );

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        userAddressId: json["user_address_id"],
        addressName: json["address_name"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        city: json["city"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "user_address_id": userAddressId,
        "address_name": addressName,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "city": city,
        "postal_code": postalCode,
      };
}

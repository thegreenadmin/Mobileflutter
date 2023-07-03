class Images {
  String? orignalUrl;
  String? dynamicUrl;

  Images({
    this.orignalUrl,
    this.dynamicUrl,
  });

  Images copyWith({
    String? orignalUrl,
    String? dynamicUrl,
  }) =>
      Images(
        orignalUrl: orignalUrl ?? this.orignalUrl,
        dynamicUrl: dynamicUrl ?? this.dynamicUrl,
      );

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        orignalUrl: json["orignal_url"],
        dynamicUrl: json["dynamic_url"],
      );

  Map<String, dynamic> toJson() => {
        "orignal_url": orignalUrl,
        "dynamic_url": dynamicUrl,
      };
}

class Permission {
  String? permissionId;
  String? controllerId;
  String? status;
  Controller? controller;
  bool? isSelected = true;

  Permission(
      {this.permissionId,
      this.controllerId,
      this.status,
      this.controller,
      this.isSelected});

  Permission.fromJson(Map<String, dynamic> json) {
    permissionId = json['permission_id'];
    controllerId = json['controller_id'];
    status = json['status'];
    controller = json['controller'] != null
        ? Controller.fromJson(json['controller'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['permission_id'] = permissionId;
    data['controller_id'] = controllerId;
    data['status'] = status;
    if (controller != null) {
      data['controller'] = controller!.toJson();
    }
    return data;
  }
}

class Controller {
  Controller({
    this.controllerId,
    this.controllerKey,
    this.controllerName,
    this.controllerDescription,
  });

  String? controllerId;
  String? controllerKey;
  String? controllerName;
  String? controllerDescription;

  Controller copyWith({
    String? controllerId,
    String? controllerKey,
    String? controllerName,
    String? controllerDescription,
  }) =>
      Controller(
        controllerId: controllerId ?? this.controllerId,
        controllerKey: controllerKey ?? this.controllerKey,
        controllerName: controllerName ?? this.controllerName,
        controllerDescription:
            controllerDescription ?? this.controllerDescription,
      );

  factory Controller.fromJson(Map<String, dynamic> json) => Controller(
        controllerId: json["controller_id"],
        controllerKey: json["controller_key"],
        controllerName: json["controller_name"],
        controllerDescription: json["controller_description"],
      );

  Map<String, dynamic> toJson() => {
        "controller_id": controllerId,
        "controller_key": controllerKey,
        "controller_name": controllerName,
        "controller_description": controllerDescription,
      };
}

class StoreUser {
  StoreUser({
    this.storeUserId,
    this.userId,
    this.storeId,
    this.isStoreOwner,
    this.description,
    this.isVerified,
    this.verifiedAt,
    this.role,
    this.storeUserTimings,
    this.user,
  });

  String? storeUserId;
  String? userId;
  String? storeId;
  bool? isStoreOwner;
  String? description;
  StoreRole? role;
  List<StoreUserTiming>? storeUserTimings;
  WorkerUser? user;
  bool? isVerified;
  DateTime? verifiedAt;

  StoreUser copyWith({
    String? storeUserId,
    String? userId,
    String? storeId,
    bool? isVerified,
    DateTime? verifiedAt,
    bool? isStoreOwner,
    String? description,
    StoreRole? role,
    List<StoreUserTiming>? storeUserTimings,
    WorkerUser? user,
  }) =>
      StoreUser(
        storeUserId: storeUserId ?? this.storeUserId,
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
        isVerified: isVerified ?? this.isVerified,
        verifiedAt: verifiedAt ?? this.verifiedAt,
        isStoreOwner: isStoreOwner ?? this.isStoreOwner,
        description: description ?? this.description,
        role: role ?? this.role,
        storeUserTimings: storeUserTimings ?? this.storeUserTimings,
        user: user ?? this.user,
      );

  factory StoreUser.fromJson(Map<String, dynamic> json) => StoreUser(
        storeUserId: json["store_user_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        isVerified: json["is_verified"],
        verifiedAt: json["verifiedAt"] == null
            ? null
            : DateTime.parse(json["verifiedAt"]),
        isStoreOwner: json["is_store_owner"],
        description: json["description"],
        role: json["role"] == null ? null : StoreRole.fromJson(json["role"]),
        storeUserTimings: json["store_user_timings"] == null
            ? []
            : List<StoreUserTiming>.from(json["store_user_timings"]!
                .map((x) => StoreUserTiming.fromJson(x))),
        user: json["user"] == null ? null : WorkerUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "store_user_id": storeUserId,
        "user_id": userId,
        "store_id": storeId,
        "is_verified": isVerified,
        "verifiedAt": verifiedAt?.toIso8601String(),
        "is_store_owner": isStoreOwner,
        "description": description,
        "role": role?.toJson(),
        "store_user_timings": storeUserTimings == null
            ? []
            : List<dynamic>.from(storeUserTimings!.map((x) => x.toJson())),
        "user": user?.toJson(),
      };
}

class WorkerUser {
  WorkerUser({
    this.userId,
    this.email,
    this.phone,
    this.phoneCode,
    this.firstName,
    this.lastName,
    this.image,
  });

  String? userId;
  String? email;
  String? phone;
  String? phoneCode;
  String? firstName;
  String? lastName;
  Images? image;

  WorkerUser copyWith({
    String? userId,
    String? email,
    String? phone,
    String? phoneCode,
    String? firstName,
    String? lastName,
    Images? image,
  }) =>
      WorkerUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        phoneCode: phoneCode ?? this.phoneCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        image: image ?? this.image,
      );

  factory WorkerUser.fromJson(Map<String, dynamic> json) => WorkerUser(
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone": phone,
        "phone_code": phoneCode,
        "first_name": firstName,
        "last_name": lastName,
        "image": image?.toJson(),
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

class ProductImages {
  String? productImageId;
  int? order;
  String? status;
  Images? image;

  ProductImages({this.productImageId, this.order, this.status, this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    productImageId = json['product_image_id'];
    order = json['order'];
    status = json['status'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_id'] = productImageId;
    data['order'] = order;
    data['status'] = status;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Logo {
  String? orignalUrl;
  String? dynamicUrl;

  Logo({this.orignalUrl, this.dynamicUrl});

  Logo.fromJson(Map<String, dynamic> json) {
    orignalUrl = json['orignal_url'];
    dynamicUrl = json['dynamic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orignal_url'] = orignalUrl;
    data['dynamic_url'] = dynamicUrl;
    return data;
  }
}

class StoreRole {
  String? roleId;
  String? roleName;
  List<Permission>? permissions;

  StoreRole({this.roleId, this.roleName, this.permissions});

  StoreRole.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    roleName = json['role_name'];
    if (json['permissions'] != null) {
      permissions = <Permission>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permission.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

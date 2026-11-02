import 'common_models.dart';

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
  dynamic dayOfWeek;
  bool? is24HrsActive;
  String? startTime;
  String? endTime;
  String? status;

  StoreUserTiming copyWith({
    String? storeUserTimingId,
    dynamic dayOfWeek,
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
  dynamic order;
  String? status;
  Images? image;

  ProductImages({this.productImageId, this.order, this.status, this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    productImageId = json['product_image_id']?.toString();
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

class Store {
  Images? image;
  Images? logo;
  bool? isFavouriteStore;
  String? storeId;
  String? storeName;
  String? storeType;
  String? storeEin;
  String? storeNickName;
  String? storePhoneCode;
  String? storeEmail;
  String? storePhone;
  bool? isVerified;
  bool? isEnabled;
  String? dynamicLink;
  bool? isfavourite;
  List<StoreAddresses>? storeAddresses;
  List<StoreTiming>? storeTimings;
  List<StoreDeliveryService>? storeDeliveryServices;
  List<StorePage>? storePages;
  String? verifiedBy;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic taxValue;


  Store({

    this.taxValue,
    this.image,
    this.logo,
    this.isFavouriteStore,
    this.storeId,
    this.storeName,
    this.storeType,
    this.storeEin,
    this.storeNickName,
    this.storePhoneCode,
    this.storeEmail,
    this.storePhone,
    this.isVerified,
    this.isEnabled,
    this.dynamicLink,
    this.isfavourite,
    this.storeAddresses,
    this.storeTimings,
    this.storeDeliveryServices,
    this.storePages,
    this.verifiedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Store copyWith({
    dynamic taxValue,
    Images? image,
    Images? logo,
    bool? isFavouriteStore,
    String? storeId,
    String? storeName,
    String? storeType,
    String? storeEin,
    String? storeNickName,
    String? storePhoneCode,
    String? storeEmail,
    String? storePhone,
    bool? isVerified,
    bool? isEnabled,
    String? dynamicLink,
    bool? isfavourite,
    List<StoreAddresses>? storeAddresses,
    List<StoreTiming>? storeTimings,
    List<StoreDeliveryService>? storeDeliveryServices,
    List<StorePage>? storePages,
    String? verifiedBy,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) =>
      Store(
        taxValue: taxValue ?? this.taxValue,
        image: image ?? this.image,
        logo: logo ?? this.logo,
        isFavouriteStore: isFavouriteStore ?? this.isFavouriteStore,
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        storeType: storeType ?? this.storeType,
        storeEin: storeEin ?? this.storeEin,
        storeNickName: storeNickName ?? this.storeNickName,
        storePhoneCode: storePhoneCode ?? this.storePhoneCode,
        storeEmail: storeEmail ?? this.storeEmail,
        storePhone: storePhone ?? this.storePhone,
        isVerified: isVerified ?? this.isVerified,
        isEnabled: isEnabled ?? this.isEnabled,
        dynamicLink: dynamicLink ?? this.dynamicLink,
        isfavourite: isfavourite ?? this.isfavourite,
        storeAddresses: storeAddresses ?? this.storeAddresses,
        storeTimings: storeTimings ?? this.storeTimings,
        storeDeliveryServices:
            storeDeliveryServices ?? this.storeDeliveryServices,
        storePages: storePages ?? this.storePages,
        verifiedBy: verifiedBy ?? this.verifiedBy,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        image: json["image"] == null ? null : Images.fromJson(json["image"]),
        logo: json["logo"] == null ? null : Images.fromJson(json["logo"]),
        isFavouriteStore: json["is_favourite_store"],
    taxValue: json["tax_value"],
        storeId: json["store_id"]?.toString(),
        storeName: json["store_name"],
        storeType: json["store_type"],
        storeEin: json["store_ein"],
        storeNickName: json["store_nick_name"],
        storePhoneCode: json["store_phone_code"],
        storeEmail: json["store_email"],
        storePhone: json["store_phone"],
        isVerified: json["is_verified"],
        isEnabled: json["is_enabled"],
        dynamicLink: json["dynamic_link"],
        isfavourite: json["isfavourite"],
        storeAddresses: json["store_addresses"] == null
            ? []
            : List<StoreAddresses>.from(json["store_addresses"]!
                .map((x) => StoreAddresses.fromJson(x))),
        storeTimings: json["store_timings"] == null
            ? []
            : List<StoreTiming>.from(
                json["store_timings"]!.map((x) => StoreTiming.fromJson(x))),
        storeDeliveryServices: json["store_delivery_services"] == null
            ? []
            : List<StoreDeliveryService>.from(json["store_delivery_services"]!
                .map((x) => StoreDeliveryService.fromJson(x))),
        storePages: json["store_pages"] == null
            ? []
            : List<StorePage>.from(
                json["store_pages"]!.map((x) => StorePage.fromJson(x))),
        verifiedBy: json['verified_by'],
        status: json['status'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "logo": logo?.toJson(),
        "is_favourite_store": isFavouriteStore,
        "store_id": storeId,
        "tax_value": taxValue,
        "store_name": storeName,
        "store_type": storeType,
        "store_ein": storeEin,
        "store_nick_name": storeNickName,
        "store_phone_code": storePhoneCode,
        "store_email": storeEmail,
        "store_phone": storePhone,
        "is_verified": isVerified,
        "verified_by": verifiedBy,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "is_enabled": isEnabled,
        "dynamic_link": dynamicLink,
        "isfavourite": isfavourite,
        "store_addresses": storeAddresses == null
            ? []
            : List<dynamic>.from(storeAddresses!.map((x) => x.toJson())),
        "store_timings": storeTimings == null
            ? []
            : List<dynamic>.from(storeTimings!.map((x) => x.toJson())),
        "store_delivery_services": storeDeliveryServices == null
            ? []
            : List<dynamic>.from(storeDeliveryServices!.map((x) => x.toJson())),
        "store_pages": storePages == null
            ? []
            : List<dynamic>.from(storePages!.map((x) => x.toJson())),
      };
}


class StorePage {
  String? storeId;
  String? storePageType;
  Images? storePageContent;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? storePageId;

  StorePage({
    this.storeId,
    this.storePageType,
    this.storePageContent,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.storePageId,
  });

  StorePage copyWith({
    String? storeId,
    String? storePageType,
    Images? storePageContent,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? storePageId,
  }) =>
      StorePage(
        storeId: storeId ?? this.storeId,
        storePageType: storePageType ?? this.storePageType,
        storePageContent: storePageContent ?? this.storePageContent,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        storePageId: storePageId ?? this.storePageId,
      );

  factory StorePage.fromJson(Map<String, dynamic> json) => StorePage(
        storeId: json["store_id"],
        storePageType: json["store_page_type"],
        storePageContent: json["store_page_content"] == null
            ? null
            : Images.fromJson(json["store_page_content"]),
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        storePageId: json["store_page_id"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_page_type": storePageType,
        "store_page_content": storePageContent?.toJson(),
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "store_page_id": storePageId,
      };
}

class StoreTiming {
  StoreTiming({
    this.storeTimingId,
    this.is24HoursActive,
    this.dayOfWeek,
    this.openingTime,
    this.closingTime,
    this.status,
  });

  String? storeTimingId;
  bool? is24HoursActive;
  dynamic dayOfWeek;
  String? openingTime;
  String? closingTime;
  String? status;

  StoreTiming copyWith({
    String? storeTimingId,
    bool? is24HoursActive,
    dynamic dayOfWeek,
    String? openingTime,
    String? closingTime,
    String? status,
  }) =>
      StoreTiming(
        storeTimingId: storeTimingId ?? this.storeTimingId,
        is24HoursActive: is24HoursActive ?? this.is24HoursActive,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        openingTime: openingTime ?? this.openingTime,
        closingTime: closingTime ?? this.closingTime,
        status: status ?? this.status,
      );

  factory StoreTiming.fromJson(Map<String, dynamic> json) => StoreTiming(
        storeTimingId: json["store_timing_id"],
        is24HoursActive: json["is_24_hours_active"],
        dayOfWeek: json["day_of_week"],
        openingTime: json["opening_time"],
        closingTime: json["closing_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "store_timing_id": storeTimingId,
        "is_24_hours_active": is24HoursActive,
        "day_of_week": dayOfWeek,
        "opening_time": openingTime,
        "closing_time": closingTime,
        "status": status,
      };
}

class StoreDeliveryService {
  StoreDeliveryService({
    this.storeDeliveryServiceId,
    this.deliveryServiceId,
    this.isEnabled,
    this.status,
    this.deliveryServiceName,
  });

  String? storeDeliveryServiceId;
  String? deliveryServiceId;
  bool? isEnabled;
  String? status;
  String? deliveryServiceName;

  StoreDeliveryService copyWith({
    String? storeDeliveryServiceId,
    String? deliveryServiceId,
    bool? isEnabled,
    String? status,
    String? deliveryServiceName,
  }) =>
      StoreDeliveryService(
        storeDeliveryServiceId:
            storeDeliveryServiceId ?? this.storeDeliveryServiceId,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        deliveryServiceName: deliveryServiceName ?? this.deliveryServiceName,
      );

  factory StoreDeliveryService.fromJson(Map<String, dynamic> json) =>
      StoreDeliveryService(
        storeDeliveryServiceId: json["store_delivery_service_id"],
        deliveryServiceId: json["delivery_service_id"],
        isEnabled: json["is_enabled"],
        status: json["status"],
        deliveryServiceName: json["delivery_service_name"],
      );

  Map<String, dynamic> toJson() => {
        "store_delivery_service_id": storeDeliveryServiceId,
        "delivery_service_id": deliveryServiceId,
        "is_enabled": isEnabled,
        "status": status,
        "delivery_service_name": deliveryServiceName,
      };
}

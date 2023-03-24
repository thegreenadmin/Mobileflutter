// // To parse this JSON data, do
// //
// //     final workerDetailResponse = workerDetailResponseFromJson(jsonString);

// import 'dart:convert';

// WorkerDetailResponse workerDetailResponseFromJson(String str) => WorkerDetailResponse.fromJson(json.decode(str));

// String workerDetailResponseToJson(WorkerDetailResponse data) => json.encode(data.toJson());

// class WorkerDetailResponse {
//   WorkerDetailResponse({
//     this.status,
//     this.message,
//     this.data,
//   });

//   int? status;
//   String? message;
//   Data? data;

//   WorkerDetailResponse copyWith({
//     int? status,
//     String? message,
//     Data? data,
//   }) =>
//       WorkerDetailResponse(
//         status: status ?? this.status,
//         message: message ?? this.message,
//         data: data ?? this.data,
//       );

//   factory WorkerDetailResponse.fromJson(Map<String, dynamic> json) => WorkerDetailResponse(
//     status: json["status"],
//     message: json["message"],
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": data?.toJson(),
//   };
// }

// class Data {
//   Data({
//     this.storeUser,
//   });

//   StoreUser? storeUser;

//   Data copyWith({
//     StoreUser? storeUser,
//   }) =>
//       Data(
//         storeUser: storeUser ?? this.storeUser,
//       );

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     storeUser: json["store_user"] == null ? null : StoreUser.fromJson(json["store_user"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "store_user": storeUser?.toJson(),
//   };
// }

// class StoreUser {
//   StoreUser({
//     this.storeUserId,
//     this.userId,
//     this.storeId,
//     this.isStoreOwner,
//     this.description,
//     this.storeUserRole,
//     this.storeUserTimings,
//     this.user,
//   });

//   String? storeUserId;
//   String? userId;
//   String? storeId;
//   bool? isStoreOwner;
//   String? description;
//   StoreUserRole? storeUserRole;
//   List<StoreUserTiming>? storeUserTimings;
//   User? user;

//   StoreUser copyWith({
//     String? storeUserId,
//     String? userId,
//     String? storeId,
//     bool? isStoreOwner,
//     String? description,
//     StoreUserRole? storeUserRole,
//     List<StoreUserTiming>? storeUserTimings,
//     User? user,
//   }) =>
//       StoreUser(
//         storeUserId: storeUserId ?? this.storeUserId,
//         userId: userId ?? this.userId,
//         storeId: storeId ?? this.storeId,
//         isStoreOwner: isStoreOwner ?? this.isStoreOwner,
//         description: description ?? this.description,
//         storeUserRole: storeUserRole ?? this.storeUserRole,
//         storeUserTimings: storeUserTimings ?? this.storeUserTimings,
//         user: user ?? this.user,
//       );

//   factory StoreUser.fromJson(Map<String, dynamic> json) => StoreUser(
//     storeUserId: json["store_user_id"],
//     userId: json["user_id"],
//     storeId: json["store_id"],
//     isStoreOwner: json["is_store_owner"],
//     description: json["description"],
//     storeUserRole: json["store_user_role"] == null ? null : StoreUserRole.fromJson(json["store_user_role"]),
//     storeUserTimings: json["store_user_timings"] == null ? [] : List<StoreUserTiming>.from(json["store_user_timings"]!.map((x) => StoreUserTiming.fromJson(x))),
//     user: json["user"] == null ? null : User.fromJson(json["user"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "store_user_id": storeUserId,
//     "user_id": userId,
//     "store_id": storeId,
//     "is_store_owner": isStoreOwner,
//     "description": description,
//     "store_user_role": storeUserRole?.toJson(),
//     "store_user_timings": storeUserTimings == null ? [] : List<dynamic>.from(storeUserTimings!.map((x) => x.toJson())),
//     "user": user?.toJson(),
//   };
// }

// class StoreUserRole {
//   StoreUserRole({
//     this.storeUserRoleId,
//     this.role,
//   });

//   String? storeUserRoleId;
//   Role? role;

//   StoreUserRole copyWith({
//     String? storeUserRoleId,
//     Role? role,
//   }) =>
//       StoreUserRole(
//         storeUserRoleId: storeUserRoleId ?? this.storeUserRoleId,
//         role: role ?? this.role,
//       );

//   factory StoreUserRole.fromJson(Map<String, dynamic> json) => StoreUserRole(
//     storeUserRoleId: json["store_user_role_id"],
//     role: json["role"] == null ? null : Role.fromJson(json["role"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "store_user_role_id": storeUserRoleId,
//     "role": role?.toJson(),
//   };
// }

// class Role {
//   Role({
//     this.roleId,
//     this.roleName,
//     this.permissions,
//   });

//   String? roleId;
//   String? roleName;
//   List<Permission>? permissions;

//   Role copyWith({
//     String? roleId,
//     String? roleName,
//     List<Permission>? permissions,
//   }) =>
//       Role(
//         roleId: roleId ?? this.roleId,
//         roleName: roleName ?? this.roleName,
//         permissions: permissions ?? this.permissions,
//       );

//   factory Role.fromJson(Map<String, dynamic> json) => Role(
//     roleId: json["role_id"],
//     roleName: json["role_name"],
//     permissions: json["permissions"] == null ? [] : List<Permission>.from(json["permissions"]!.map((x) => Permission.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "role_id": roleId,
//     "role_name": roleName,
//     "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
//   };
// }

// class Permission {
//   Permission({
//     this.permissionId,
//     this.controller,
//   });

//   String? permissionId;
//   Controller? controller;

//   Permission copyWith({
//     String? permissionId,
//     Controller? controller,
//   }) =>
//       Permission(
//         permissionId: permissionId ?? this.permissionId,
//         controller: controller ?? this.controller,
//       );

//   factory Permission.fromJson(Map<String, dynamic> json) => Permission(
//     permissionId: json["permission_id"],
//     controller: json["controller"] == null ? null : Controller.fromJson(json["controller"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "permission_id": permissionId,
//     "controller": controller?.toJson(),
//   };
// }

// class Controller {
//   Controller({
//     this.controllerId,
//     this.controllerKey,
//     this.controllerName,
//   });

//   String? controllerId;
//   String? controllerKey;
//   String? controllerName;

//   Controller copyWith({
//     String? controllerId,
//     String? controllerKey,
//     String? controllerName,
//   }) =>
//       Controller(
//         controllerId: controllerId ?? this.controllerId,
//         controllerKey: controllerKey ?? this.controllerKey,
//         controllerName: controllerName ?? this.controllerName,
//       );

//   factory Controller.fromJson(Map<String, dynamic> json) => Controller(
//     controllerId: json["controller_id"],
//     controllerKey: json["controller_key"],
//     controllerName: json["controller_name"],
//   );

//   Map<String, dynamic> toJson() => {
//     "controller_id": controllerId,
//     "controller_key": controllerKey,
//     "controller_name": controllerName,
//   };
// }

// class StoreUserTiming {
//   StoreUserTiming({
//     this.storeUserTimingId,
//     this.dayOfWeek,
//     this.is24HrsActive,
//     this.startTime,
//     this.endTime,
//     this.status,
//   });

//   String? storeUserTimingId;
//   int? dayOfWeek;
//   bool? is24HrsActive;
//   String? startTime;
//   String? endTime;
//   String? status;

//   StoreUserTiming copyWith({
//     String? storeUserTimingId,
//     int? dayOfWeek,
//     bool? is24HrsActive,
//     String? startTime,
//     String? endTime,
//     String? status,
//   }) =>
//       StoreUserTiming(
//         storeUserTimingId: storeUserTimingId ?? this.storeUserTimingId,
//         dayOfWeek: dayOfWeek ?? this.dayOfWeek,
//         is24HrsActive: is24HrsActive ?? this.is24HrsActive,
//         startTime: startTime ?? this.startTime,
//         endTime: endTime ?? this.endTime,
//         status: status ?? this.status,
//       );

//   factory StoreUserTiming.fromJson(Map<String, dynamic> json) => StoreUserTiming(
//     storeUserTimingId: json["store_user_timing_id"],
//     dayOfWeek: json["day_of_week"],
//     is24HrsActive: json["is_24_hrs_active"],
//     startTime: json["start_time"],
//     endTime: json["end_time"],
//     status: json["status"],
//   );

//   Map<String, dynamic> toJson() => {
//     "store_user_timing_id": storeUserTimingId,
//     "day_of_week": dayOfWeek,
//     "is_24_hrs_active": is24HrsActive,
//     "start_time": startTime,
//     "end_time": endTime,
//     "status": status,
//   };
// }

// class User {
//   User({
//     this.userId,
//     this.email,
//     this.phone,
//     this.firstName,
//     this.lastName,
//     this.image,
//   });

//   String? userId;
//   String? email;
//   String? phone;
//   String? firstName;
//   dynamic lastName;
//   Image? image;

//   User copyWith({
//     String? userId,
//     String? email,
//     String? phone,
//     String? firstName,
//     dynamic lastName,
//     Image? image,
//   }) =>
//       User(
//         userId: userId ?? this.userId,
//         email: email ?? this.email,
//         phone: phone ?? this.phone,
//         firstName: firstName ?? this.firstName,
//         lastName: lastName ?? this.lastName,
//         image: image ?? this.image,
//       );

//   factory User.fromJson(Map<String, dynamic> json) => User(
//     userId: json["user_id"],
//     email: json["email"],
//     phone: json["phone"],
//     firstName: json["first_name"],
//     lastName: json["last_name"],
//     image: json["image"] == null ? null : Image.fromJson(json["image"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "email": email,
//     "phone": phone,
//     "first_name": firstName,
//     "last_name": lastName,
//     "image": image?.toJson(),
//   };
// }

// class Image {
//   Image({
//     this.orignalUrl,
//     this.dynamicUrl,
//   });

//   String? orignalUrl;
//   String? dynamicUrl;

//   Image copyWith({
//     String? orignalUrl,
//     String? dynamicUrl,
//   }) =>
//       Image(
//         orignalUrl: orignalUrl ?? this.orignalUrl,
//         dynamicUrl: dynamicUrl ?? this.dynamicUrl,
//       );

//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//     orignalUrl: json["orignal_url"],
//     dynamicUrl: json["dynamic_url"],
//   );

//   Map<String, dynamic> toJson() => {
//     "orignal_url": orignalUrl,
//     "dynamic_url": dynamicUrl,
//   };
// }


// To parse this JSON data, do
//
//     final workerDetailResponse = workerDetailResponseFromJson(jsonString);

// To parse this JSON data, do
//
//     final workerDetailResponse = workerDetailResponseFromJson(jsonString);

import 'dart:convert';

WorkerDetailResponse workerDetailResponseFromJson(String str) => WorkerDetailResponse.fromJson(json.decode(str));

String workerDetailResponseToJson(WorkerDetailResponse data) => json.encode(data.toJson());

class WorkerDetailResponse {
    WorkerDetailResponse({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    WorkerDetailResponse copyWith({
        int? status,
        String? message,
        Data? data,
    }) => 
        WorkerDetailResponse(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory WorkerDetailResponse.fromJson(Map<String, dynamic> json) => WorkerDetailResponse(
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
        this.storeUser,
    });

    StoreUser? storeUser;

    Data copyWith({
        StoreUser? storeUser,
    }) => 
        Data(
            storeUser: storeUser ?? this.storeUser,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeUser: json["store_user"] == null ? null : StoreUser.fromJson(json["store_user"]),
    );

    Map<String, dynamic> toJson() => {
        "store_user": storeUser?.toJson(),
    };
}

class StoreUser {
    StoreUser({
        this.storeUserId,
        this.userId,
        this.storeId,
        this.isStoreOwner,
        this.description,
        this.storeUserRole,
        this.storeUserTimings,
        this.user,
    });

    String? storeUserId;
    String? userId;
    String? storeId;
    bool? isStoreOwner;
    String? description;
    StoreUserRole? storeUserRole;
    List<StoreUserTiming>? storeUserTimings;
    User? user;

    StoreUser copyWith({
        String? storeUserId,
        String? userId,
        String? storeId,
        bool? isStoreOwner,
        String? description,
        StoreUserRole? storeUserRole,
        List<StoreUserTiming>? storeUserTimings,
        User? user,
    }) => 
        StoreUser(
            storeUserId: storeUserId ?? this.storeUserId,
            userId: userId ?? this.userId,
            storeId: storeId ?? this.storeId,
            isStoreOwner: isStoreOwner ?? this.isStoreOwner,
            description: description ?? this.description,
            storeUserRole: storeUserRole ?? this.storeUserRole,
            storeUserTimings: storeUserTimings ?? this.storeUserTimings,
            user: user ?? this.user,
        );

    factory StoreUser.fromJson(Map<String, dynamic> json) => StoreUser(
        storeUserId: json["store_user_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        isStoreOwner: json["is_store_owner"],
        description: json["description"],
        storeUserRole: json["store_user_role"] == null ? null : StoreUserRole.fromJson(json["store_user_role"]),
        storeUserTimings: json["store_user_timings"] == null ? [] : List<StoreUserTiming>.from(json["store_user_timings"]!.map((x) => StoreUserTiming.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "store_user_id": storeUserId,
        "user_id": userId,
        "store_id": storeId,
        "is_store_owner": isStoreOwner,
        "description": description,
        "store_user_role": storeUserRole?.toJson(),
        "store_user_timings": storeUserTimings == null ? [] : List<dynamic>.from(storeUserTimings!.map((x) => x.toJson())),
        "user": user?.toJson(),
    };
}

class StoreUserRole {
    StoreUserRole({
        this.storeUserRoleId,
        this.role,
    });

    String? storeUserRoleId;
    Role? role;

    StoreUserRole copyWith({
        String? storeUserRoleId,
        Role? role,
    }) => 
        StoreUserRole(
            storeUserRoleId: storeUserRoleId ?? this.storeUserRoleId,
            role: role ?? this.role,
        );

    factory StoreUserRole.fromJson(Map<String, dynamic> json) => StoreUserRole(
        storeUserRoleId: json["store_user_role_id"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
    );

    Map<String, dynamic> toJson() => {
        "store_user_role_id": storeUserRoleId,
        "role": role?.toJson(),
    };
}

class Role {
    Role({
        this.roleId,
        this.roleName,
        this.permissions,
    });

    String? roleId;
    String? roleName;
    List<Permission>? permissions;

    Role copyWith({
        String? roleId,
        String? roleName,
        List<Permission>? permissions,
    }) => 
        Role(
            roleId: roleId ?? this.roleId,
            roleName: roleName ?? this.roleName,
            permissions: permissions ?? this.permissions,
        );

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["role_id"],
        roleName: json["role_name"],
        permissions: json["permissions"] == null ? [] : List<Permission>.from(json["permissions"]!.map((x) => Permission.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role_name": roleName,
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
    };
}

class Permission {
    Permission({
        this.permissionId,
        this.controller,
    });

    String? permissionId;
    Controller? controller;

    Permission copyWith({
        String? permissionId,
        Controller? controller,
    }) => 
        Permission(
            permissionId: permissionId ?? this.permissionId,
            controller: controller ?? this.controller,
        );

    factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        permissionId: json["permission_id"],
        controller: json["controller"] == null ? null : Controller.fromJson(json["controller"]),
    );

    Map<String, dynamic> toJson() => {
        "permission_id": permissionId,
        "controller": controller?.toJson(),
    };
}

class Controller {
    Controller({
        this.controllerId,
        this.controllerKey,
        this.controllerName,
    });

    String? controllerId;
    String? controllerKey;
    String? controllerName;

    Controller copyWith({
        String? controllerId,
        String? controllerKey,
        String? controllerName,
    }) => 
        Controller(
            controllerId: controllerId ?? this.controllerId,
            controllerKey: controllerKey ?? this.controllerKey,
            controllerName: controllerName ?? this.controllerName,
        );

    factory Controller.fromJson(Map<String, dynamic> json) => Controller(
        controllerId: json["controller_id"],
        controllerKey: json["controller_key"],
        controllerName: json["controller_name"],
    );

    Map<String, dynamic> toJson() => {
        "controller_id": controllerId,
        "controller_key": controllerKey,
        "controller_name": controllerName,
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

    factory StoreUserTiming.fromJson(Map<String, dynamic> json) => StoreUserTiming(
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
    Image? image;

    User copyWith({
        String? userId,
        String? email,
        String? phone,
        String? phoneCode,
        String? firstName,
        String? lastName,
        Image? image,
    }) => 
        User(
            userId: userId ?? this.userId,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            phoneCode: phoneCode ?? this.phoneCode,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            image: image ?? this.image,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
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


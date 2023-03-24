class GetStoreDetailModel {
  int? status;
  String? message;
  Data? data;

  GetStoreDetailModel({this.status, this.message, this.data});

  GetStoreDetailModel.fromJson(Map<String, dynamic> json) {
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
  Role? role;

  Data({this.role});

  Data.fromJson(Map<String, dynamic> json) {
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

class Role {
  String? roleId;
  String? roleName;
  List<Permission>? permissions;

  Role({this.roleId, this.roleName, this.permissions});

  Role.fromJson(Map<String, dynamic> json) {
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
  String? controllerKey;
  String? controllerName;
  String? controllerDescription;

  Controller(
      {this.controllerKey, this.controllerName, this.controllerDescription});

  Controller.fromJson(Map<String, dynamic> json) {
    controllerKey = json['controller_key'];
    controllerName = json['controller_name'];
    controllerDescription = json['controller_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['controller_key'] = controllerKey;
    data['controller_name'] = controllerName;
    data['controller_description'] = controllerDescription;
    return data;
  }
}

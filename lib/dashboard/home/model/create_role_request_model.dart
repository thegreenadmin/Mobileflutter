class CreateRoleRequestModel {
  int? storeId;
  String? roleName;
  List<Permissions>? permissions;

  CreateRoleRequestModel({this.storeId, this.roleName, this.permissions});

  CreateRoleRequestModel.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    roleName = json['role_name'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['role_name'] = roleName;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permissions {
  int? controllerId;

  Permissions({this.controllerId});

  Permissions.fromJson(Map<String, dynamic> json) {
    controllerId = json['controller_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['controller_id'] = controllerId;
    return data;
  }
}

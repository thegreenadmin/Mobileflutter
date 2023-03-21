class GetRoleListModel {
  int? status;
  String? message;
  Data? data;

  GetRoleListModel({this.status, this.message, this.data});

  GetRoleListModel.fromJson(Map<String, dynamic> json) {
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
  List<StoreRoles>? storeRoles;

  Data({this.storeRoles});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['store_roles'] != null) {
      storeRoles = <StoreRoles>[];
      json['store_roles'].forEach((v) {
        storeRoles!.add(StoreRoles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (storeRoles != null) {
      data['store_roles'] = storeRoles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoreRoles {
  String? roleId;
  String? roleName;

  StoreRoles({this.roleId, this.roleName});

  StoreRoles.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    return data;
  }
}

class DeleteRoleRequestModel {
  int? storeId;
  int? roleId;

  DeleteRoleRequestModel({this.storeId, this.roleId});

  DeleteRoleRequestModel.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['role_id'] = roleId;
    return data;
  }
}

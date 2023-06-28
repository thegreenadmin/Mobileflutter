class QuantityType {
  String? quantityTypeId;
  String? quantityTypeName;
  String? status;

  QuantityType({this.quantityTypeId, this.quantityTypeName, this.status});

  QuantityType.fromJson(Map<String, dynamic> json) {
    quantityTypeId = json['quantity_type_id'];
    quantityTypeName = json['quantity_type_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity_type_id'] = quantityTypeId;
    data['quantity_type_name'] = quantityTypeName;
    data['status'] = status;
    return data;
  }
}
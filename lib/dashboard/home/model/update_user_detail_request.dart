class UpdateUserDeatilRequestModel {
  UpdateUser? user;
  Address? address;

  UpdateUserDeatilRequestModel({this.user, this.address});

  UpdateUserDeatilRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UpdateUser.fromJson(json['user']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class UpdateUser {
  String? firstName;
  String? lastName;
  String? nickName;

  UpdateUser({this.firstName, this.lastName, this.nickName});

  UpdateUser.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['nick_name'] = nickName;
    return data;
  }
}

class Address {
  dynamic userAddressId;
  int? stateId;
  String? addressName;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? postalCode;

  Address(
      {this.userAddressId,
      this.stateId,
      this.addressName,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.postalCode});

  Address.fromJson(Map<String, dynamic> json) {
    userAddressId = json['user_address_id'];
    stateId = json['state_id'];
    addressName = json['address_name'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_address_id'] = userAddressId;
    data['state_id'] = stateId;
    data['address_name'] = addressName;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['city'] = city;
    data['postal_code'] = postalCode;
    return data;
  }
}

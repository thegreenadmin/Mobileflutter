class UpdateUserDeatilRequestModel {
  User? user;
  Address? address;

  UpdateUserDeatilRequestModel({this.user, this.address});

  UpdateUserDeatilRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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

class User {
  String? firstName;
  String? lastName;
  String? nickName;

  User({this.firstName, this.lastName, this.nickName});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['nick_name'] = this.nickName;
    return data;
  }
}

class Address {
  Null? userAddressId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_address_id'] = this.userAddressId;
    data['state_id'] = this.stateId;
    data['address_name'] = this.addressName;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    return data;
  }
}

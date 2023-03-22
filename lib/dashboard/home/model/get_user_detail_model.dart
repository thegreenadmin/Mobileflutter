class GetUserDetailModel {
  int? status;
  String? message;
  Data? data;

  GetUserDetailModel({status, message, this.data});

  GetUserDetailModel.fromJson(Map<String, dynamic> json) {
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
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? firstName;
  String? lastName;
  String? nickName;
  String? email;
  String? phone;
  List<UserAddresses>? userAddresses;

  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.nickName,
      this.email,
      this.phone,
      this.userAddresses});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
    email = json['email'];
    phone = json['phone'];
    if (json['user_addresses'] != null) {
      userAddresses = <UserAddresses>[];
      json['user_addresses'].forEach((v) {
        userAddresses!.add(UserAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['nick_name'] = nickName;
    data['email'] = email;
    data['phone'] = phone;
    if (userAddresses != null) {
      data['user_addresses'] = userAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddresses {
  String? userAddressId;
  String? addressName;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? postalCode;
  State? state;

  UserAddresses(
      {this.userAddressId,
      this.addressName,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.postalCode,
      this.state});

  UserAddresses.fromJson(Map<String, dynamic> json) {
    userAddressId = json['user_address_id'];
    addressName = json['address_name'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    postalCode = json['postal_code'];
    state = json['state'] != null ? State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_address_id'] = userAddressId;
    data['address_name'] = addressName;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['city'] = city;
    data['postal_code'] = postalCode;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}

class State {
  String? stateId;
  String? stateName;
  Country? country;

  State({stateId, stateName, country});

  State.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}

class Country {
  String? countryId;
  String? countryName;

  Country({countryId, countryName});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    return data;
  }
}

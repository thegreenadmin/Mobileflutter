class GetUserDetailModel {
  int? status;
  String? message;
  Data? data;

  GetUserDetailModel({this.status, this.message, this.data});

  GetUserDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  UserProof? userProof;

  Data({this.user, this.userProof});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userProof = json['user_proof'] != null
        ? new UserProof.fromJson(json['user_proof'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userProof != null) {
      data['user_proof'] = this.userProof!.toJson();
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
  String? phoneCode;
  List<UserAddresses>? userAddresses;

  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.nickName,
      this.email,
      this.phone,
      this.phoneCode,
      this.userAddresses});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
    email = json['email'];
    phone = json['phone'];
    phoneCode = json['phone_code'];
    if (json['user_addresses'] != null) {
      userAddresses = <UserAddresses>[];
      json['user_addresses'].forEach((v) {
        userAddresses!.add(new UserAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['nick_name'] = this.nickName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['phone_code'] = this.phoneCode;
    if (this.userAddresses != null) {
      data['user_addresses'] =
          this.userAddresses!.map((v) => v.toJson()).toList();
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
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_address_id'] = this.userAddressId;
    data['address_name'] = this.addressName;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    return data;
  }
}

class State {
  String? stateId;
  String? stateName;
  Country? country;

  State({this.stateId, this.stateName, this.country});

  State.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    return data;
  }
}

class Country {
  String? countryId;
  String? countryName;

  Country({this.countryId, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    return data;
  }
}

class UserProof {
  Image? image;
  String? userId;
  String? proofTypeId;
  String? proofValue;
  bool? isVerified;
  Null? expiredAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userProofId;
  ProofType? proofType;

  UserProof(
      {this.image,
      this.userId,
      this.proofTypeId,
      this.proofValue,
      this.isVerified,
      this.expiredAt,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userProofId,
      this.proofType});

  UserProof.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    userId = json['user_id'];
    proofTypeId = json['proof_type_id'];
    proofValue = json['proof_value'];
    isVerified = json['is_verified'];
    expiredAt = json['expiredAt'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userProofId = json['user_proof_id'];
    proofType = json['proof_type'] != null
        ? new ProofType.fromJson(json['proof_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['user_id'] = this.userId;
    data['proof_type_id'] = this.proofTypeId;
    data['proof_value'] = this.proofValue;
    data['is_verified'] = this.isVerified;
    data['expiredAt'] = this.expiredAt;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_proof_id'] = this.userProofId;
    if (this.proofType != null) {
      data['proof_type'] = this.proofType!.toJson();
    }
    return data;
  }
}

class Image {
  String? orignalUrl;
  String? dynamicUrl;

  Image({this.orignalUrl, this.dynamicUrl});

  Image.fromJson(Map<String, dynamic> json) {
    orignalUrl = json['orignal_url'];
    dynamicUrl = json['dynamic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orignal_url'] = this.orignalUrl;
    data['dynamic_url'] = this.dynamicUrl;
    return data;
  }
}

class ProofType {
  String? id;
  String? proofName;
  bool? hasExpiration;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;

  ProofType(
      {this.id,
      this.proofName,
      this.hasExpiration,
      this.isEnabled,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProofType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    proofName = json['proof_name'];
    hasExpiration = json['has_expiration'];
    isEnabled = json['is_enabled'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['proof_name'] = this.proofName;
    data['has_expiration'] = this.hasExpiration;
    data['is_enabled'] = this.isEnabled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class GetUserDetailModel {
  int? status;
  String? message;
  Data? data;

  GetUserDetailModel({this.status, this.message, this.data});

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
  UserProof? userProof;

  Data({this.user, this.userProof});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userProof = json['user_proof'] != null
        ? UserProof.fromJson(json['user_proof'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userProof != null) {
      data['user_proof'] = userProof!.toJson();
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
  bool? hasStoreAccess;
  List<UserAddresses>? userAddresses;

  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.nickName,
      this.email,
      this.phone,
      this.phoneCode,
      this.hasStoreAccess,
      this.userAddresses});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
    email = json['email'];
    phone = json['phone'];
    phoneCode = json['phone_code'];
    hasStoreAccess = json['has_store_access'];
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
    data['phone_code'] = phoneCode;
    data['has_store_access'] = hasStoreAccess;
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

  State({this.stateId, this.stateName, this.country});

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

  Country({this.countryId, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    return data;
  }
}

class UserProof {
  Images? image;
  String? userId;
  String? proofTypeId;
  String? proofValue;
  bool? isVerified;
  String? expiredAt;
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
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
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
        ? ProofType.fromJson(json['proof_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['user_id'] = userId;
    data['proof_type_id'] = proofTypeId;
    data['proof_value'] = proofValue;
    data['is_verified'] = isVerified;
    data['expiredAt'] = expiredAt;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user_proof_id'] = userProofId;
    if (proofType != null) {
      data['proof_type'] = proofType!.toJson();
    }
    return data;
  }
}

class Images {
  String? orignalUrl;
  String? dynamicUrl;

  Images({this.orignalUrl, this.dynamicUrl});

  Images.fromJson(Map<String, dynamic> json) {
    orignalUrl = json['orignal_url'];
    dynamicUrl = json['dynamic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orignal_url'] = orignalUrl;
    data['dynamic_url'] = dynamicUrl;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['proof_name'] = proofName;
    data['has_expiration'] = hasExpiration;
    data['is_enabled'] = isEnabled;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

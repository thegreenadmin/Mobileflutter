import 'model.dart';

class GetUserDetailModel {
  int? status;
  String? message;
  UserDetailData? data;

  GetUserDetailModel({status, message, this.data});

  GetUserDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserDetailData.fromJson(json['data']) : null;
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

class UserDetailData {
  User? user;
  UserProof? userProof;

  UserDetailData({this.user, this.userProof});

  UserDetailData.fromJson(Map<String, dynamic> json) {
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
  String? uuId;
  String? firstName;
  String? lastName;
  String? nickName;
  String? email;
  String? phone;
  bool? hasStoreAccess;
  List<UserAddresses>? userAddresses;

  User(
      {this.userId,this.uuId,
      this.firstName,
      this.lastName,
      this.nickName,
      this.email,
      this.phone,
      this.hasStoreAccess,
      this.userAddresses});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    uuId = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    nickName = json['nick_name'];
    email = json['email'];
    phone = json['phone'];
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
    data['uuid'] = uuId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['nick_name'] = nickName;
    data['email'] = email;
    data['phone'] = phone;
    data['has_store_access'] = hasStoreAccess;
    if (userAddresses != null) {
      data['user_addresses'] = userAddresses!.map((v) => v.toJson()).toList();
    }
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

class UserAddresses {
  String? userAddressId;
  String? addressName;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? postalCode;
  State? state;
  bool? isSelected;

  UserAddresses(
      {this.userAddressId,
      this.addressName,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.postalCode,
      this.isSelected,
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

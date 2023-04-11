class UserInboxModel {
  int? status;
  String? message;
  Data? data;

  UserInboxModel({this.status, this.message, this.data});

  UserInboxModel.fromJson(Map<String, dynamic> json) {
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
  int? totalCount;
  List<MessageHeads>? messageHeads;

  Data({this.totalCount, this.messageHeads});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['message_heads'] != null) {
      messageHeads = <MessageHeads>[];
      json['message_heads'].forEach((v) {
        messageHeads!.add(new MessageHeads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.messageHeads != null) {
      data['message_heads'] =
          this.messageHeads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageHeads {
  String? storeId;
  String? offerId;
  String? orderId;
  String? userId;
  bool? isAvailableForStore;
  bool? isAvailableForUser;
  bool? isCompleted;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? messageHeadId;
  Store? store;
  Offer? offer;

  MessageHeads(
      {this.storeId,
      this.offerId,
      this.orderId,
      this.userId,
      this.isAvailableForStore,
      this.isAvailableForUser,
      this.isCompleted,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.messageHeadId,
      this.store,
      this.offer});

  MessageHeads.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    offerId = json['offer_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    isAvailableForStore = json['is_available_for_store'];
    isAvailableForUser = json['is_available_for_user'];
    isCompleted = json['is_completed'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    messageHeadId = json['message_head_id'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['offer_id'] = this.offerId;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['is_available_for_store'] = this.isAvailableForStore;
    data['is_available_for_user'] = this.isAvailableForUser;
    data['is_completed'] = this.isCompleted;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['message_head_id'] = this.messageHeadId;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    return data;
  }
}

class Store {
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storeEmail;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  String? verifiedBy;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storeId;
  Logo? logo;

  Store(
      {this.storeName,
      this.storeEin,
      this.storeNickName,
      this.storeEmail,
      this.storePhone,
      this.storePhoneCode,
      this.isVerified,
      this.verifiedBy,
      this.isEnabled,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.storeId,
      this.logo});

  Store.fromJson(Map<String, dynamic> json) {
    storeName = json['store_name'];
    storeEin = json['store_ein'];
    storeNickName = json['store_nick_name'];
    storeEmail = json['store_email'];
    storePhone = json['store_phone'];
    storePhoneCode = json['store_phone_code'];
    isVerified = json['is_verified'];
    verifiedBy = json['verified_by'];
    isEnabled = json['is_enabled'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    storeId = json['store_id'];
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_name'] = this.storeName;
    data['store_ein'] = this.storeEin;
    data['store_nick_name'] = this.storeNickName;
    data['store_email'] = this.storeEmail;
    data['store_phone'] = this.storePhone;
    data['store_phone_code'] = this.storePhoneCode;
    data['is_verified'] = this.isVerified;
    data['verified_by'] = this.verifiedBy;
    data['is_enabled'] = this.isEnabled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['store_id'] = this.storeId;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    return data;
  }
}

class Logo {
  String? orignalUrl;
  String? dynamicUrl;

  Logo({this.orignalUrl, this.dynamicUrl});

  Logo.fromJson(Map<String, dynamic> json) {
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

class Offer {
  String? storeId;
  bool? isOfferForStore;
  String? offerName;
  String? imageUrl;
  String? offerType;
  int? offerValue;
  bool? isExpired;
  String? expiredAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? offerId;

  Offer(
      {this.storeId,
      this.isOfferForStore,
      this.offerName,
      this.imageUrl,
      this.offerType,
      this.offerValue,
      this.isExpired,
      this.expiredAt,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.offerId});

  Offer.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    isOfferForStore = json['is_offer_for_store'];
    offerName = json['offer_name'];
    imageUrl = json['image_url'];
    offerType = json['offer_type'];
    offerValue = json['offer_value'];
    isExpired = json['is_expired'];
    expiredAt = json['expiredAt'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    offerId = json['offer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['is_offer_for_store'] = this.isOfferForStore;
    data['offer_name'] = this.offerName;
    data['image_url'] = this.imageUrl;
    data['offer_type'] = this.offerType;
    data['offer_value'] = this.offerValue;
    data['is_expired'] = this.isExpired;
    data['expiredAt'] = this.expiredAt;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['offer_id'] = this.offerId;
    return data;
  }
}

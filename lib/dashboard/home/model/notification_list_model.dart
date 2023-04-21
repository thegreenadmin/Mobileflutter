class NotificationListModel {
  int? status;
  String? message;
  Data? data;

  NotificationListModel({this.status, this.message, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
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
  List<Notifications>? notifications;

  Data({this.totalCount, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? userId;
  String? storeId;
  Null? messageHeadId;
  String? orderId;
  Null? offerId;
  bool? isNotificationForStore;
  bool? isSent;
  String? title;
  String? message;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? notificationId;
  Store? store;

  Notifications(
      {this.userId,
      this.storeId,
      this.messageHeadId,
      this.orderId,
      this.offerId,
      this.isNotificationForStore,
      this.isSent,
      this.title,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.notificationId,
      this.store});

  Notifications.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    storeId = json['store_id'];
    messageHeadId = json['message_head_id'];
    orderId = json['order_id'];
    offerId = json['offer_id'];
    isNotificationForStore = json['is_notification_for_store'];
    isSent = json['is_sent'];
    title = json['title'];
    message = json['message'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notificationId = json['notification_id'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['message_head_id'] = this.messageHeadId;
    data['order_id'] = this.orderId;
    data['offer_id'] = this.offerId;
    data['is_notification_for_store'] = this.isNotificationForStore;
    data['is_sent'] = this.isSent;
    data['title'] = this.title;
    data['message'] = this.message;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['notification_id'] = this.notificationId;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
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
  Null? verifiedBy;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storeId;
  Logo? logo;
  Logo? image;

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
      this.logo,
      this.image});

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
    image = json['image'] != null ? new Logo.fromJson(json['image']) : null;
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
    if (this.image != null) {
      data['image'] = this.image!.toJson();
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

import 'model.dart';

class NotificationListModel {
  int? status;
  String? message;
  NotificationListData? data;

  NotificationListModel({this.status, this.message, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? NotificationListData.fromJson(json['data'])
        : null;
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

class NotificationListData {
  int? totalCount;
  List<Notifications>? notifications;

  NotificationListData({this.totalCount, this.notifications});

  NotificationListData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? userId;
  String? storeId;
  String? messageHeadId;
  String? orderId;
  String? offerId;
  bool? isNotificationForStore;
  bool? isSent;
  bool? isRead;
  String? title;
  String? message;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? notificationId;
  NotificationListStore? store;

  Notifications(
      {this.userId,
      this.storeId,
      this.messageHeadId,
      this.orderId,
      this.offerId,
      this.isNotificationForStore,
      this.isSent,
      this.isRead,
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
    isRead = json['is_read'];
    title = json['title'];
    message = json['message'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notificationId = json['notification_id'];
    store = json['store'] != null
        ? NotificationListStore.fromJson(json['store'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['message_head_id'] = messageHeadId;
    data['order_id'] = orderId;
    data['offer_id'] = offerId;
    data['is_notification_for_store'] = isNotificationForStore;
    data['is_sent'] = isSent;
    data['is_read'] = isRead;
    data['title'] = title;
    data['message'] = message;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['notification_id'] = notificationId;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

class NotificationListStore {
  String? storeName;
  String? storeEin;
  String? storeNickName;
  String? storeEmail;
  String? storePhone;
  String? storePhoneCode;
  bool? isVerified;
  dynamic verifiedBy;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? storeId;
  Logo? logo;
  Logo? image;

  NotificationListStore(
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

  NotificationListStore.fromJson(Map<String, dynamic> json) {
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
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    image = json['image'] != null ? Logo.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_name'] = storeName;
    data['store_ein'] = storeEin;
    data['store_nick_name'] = storeNickName;
    data['store_email'] = storeEmail;
    data['store_phone'] = storePhone;
    data['store_phone_code'] = storePhoneCode;
    data['is_verified'] = isVerified;
    data['verified_by'] = verifiedBy;
    data['is_enabled'] = isEnabled;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['store_id'] = storeId;
    if (logo != null) {
      data['logo'] = logo!.toJson();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class NotificationStatusModel {
  int? status;
  String? message;
  NotificationStatusData? data;

  NotificationStatusModel({this.status, this.message, this.data});

  NotificationStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? NotificationStatusData.fromJson(json['data'])
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

class NotificationStatusData {
  List<NotificationSettings>? notificationSettings;

  NotificationStatusData({this.notificationSettings});

  NotificationStatusData.fromJson(Map<String, dynamic> json) {
    if (json['notification_settings'] != null) {
      notificationSettings = <NotificationSettings>[];
      json['notification_settings'].forEach((v) {
        notificationSettings!.add(NotificationSettings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notificationSettings != null) {
      data['notification_settings'] =
          notificationSettings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationSettings {
  String? userId;
  String? notificationType;
  bool? isForStore;
  bool? isEnabled;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? notificaitonSettingId;

  NotificationSettings(
      {this.userId,
      this.notificationType,
      this.isForStore,
      this.isEnabled,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.notificaitonSettingId});

  NotificationSettings.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    notificationType = json['notification_type'];
    isForStore = json['is_for_store'];
    isEnabled = json['is_enabled'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notificaitonSettingId = json['notificaiton_setting_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['notification_type'] = notificationType;
    data['is_for_store'] = isForStore;
    data['is_enabled'] = isEnabled;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['notificaiton_setting_id'] = notificaitonSettingId;
    return data;
  }
}

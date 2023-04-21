class NotificationStatusModel {
  int? status;
  String? message;
  Data? data;

  NotificationStatusModel({this.status, this.message, this.data});

  NotificationStatusModel.fromJson(Map<String, dynamic> json) {
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
  List<NotificationSettings>? notificationSettings;

  Data({this.notificationSettings});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notification_settings'] != null) {
      notificationSettings = <NotificationSettings>[];
      json['notification_settings'].forEach((v) {
        notificationSettings!.add(new NotificationSettings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationSettings != null) {
      data['notification_settings'] =
          this.notificationSettings!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['notification_type'] = this.notificationType;
    data['is_for_store'] = this.isForStore;
    data['is_enabled'] = this.isEnabled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['notificaiton_setting_id'] = this.notificaitonSettingId;
    return data;
  }
}

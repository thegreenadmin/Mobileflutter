class UserMessageListModel {
  int? status;
  String? message;
  Data? data;

  UserMessageListModel({this.status, this.message, this.data});

  UserMessageListModel.fromJson(Map<String, dynamic> json) {
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
  int? totalCount;
  List<Messages>? messages;

  Data({this.totalCount, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? messageHeadId;
  String? senderType;
  String? message;
  bool? isUserRead;
  bool? isStoreRead;
  bool? isCurrentMessage;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? messageId;
  Images? image;

  Messages(
      {this.messageHeadId,
      this.senderType,
      this.message,
      this.isUserRead,
      this.isStoreRead,
      this.isCurrentMessage,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.messageId,
      this.image});

  Messages.fromJson(Map<String, dynamic> json) {
    messageHeadId = json['message_head_id'];
    senderType = json['sender_type'];
    message = json['message'];
    isUserRead = json['is_user_read'];
    isStoreRead = json['is_store_read'];
    isCurrentMessage = json['is_current_message'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    messageId = json['message_id'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_head_id'] = messageHeadId;
    data['sender_type'] = senderType;
    data['message'] = message;
    data['is_user_read'] = isUserRead;
    data['is_store_read'] = isStoreRead;
    data['is_current_message'] = isCurrentMessage;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['message_id'] = messageId;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Images {
  String? orignalUrl;
  String? dynamicUrl;

  Images({orignalUrl, dynamicUrl});

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

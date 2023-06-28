import 'model.dart';
class OwnerMessageListModel {
  int? status;
  String? message;
  OwnerMessageListData? data;

  OwnerMessageListModel({this.status, this.message, this.data});

  OwnerMessageListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? OwnerMessageListData.fromJson(json['data'])
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

class OwnerMessageListData {
  int? totalCount;
  List<Message>? messages;

  OwnerMessageListData({this.totalCount, this.messages});

  OwnerMessageListData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
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

class Message {
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

  Message(
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

  Message.fromJson(Map<String, dynamic> json) {
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

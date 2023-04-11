class OwnerMessageListModel {
  int? status;
  String? message;
  Data? data;

  OwnerMessageListModel({this.status, this.message, this.data});

  OwnerMessageListModel.fromJson(Map<String, dynamic> json) {
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
  List<Message>? messages;

  Data({this.totalCount, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
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
  Image? image;

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
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_head_id'] = this.messageHeadId;
    data['sender_type'] = this.senderType;
    data['message'] = this.message;
    data['is_user_read'] = this.isUserRead;
    data['is_store_read'] = this.isStoreRead;
    data['is_current_message'] = this.isCurrentMessage;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['message_id'] = this.messageId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
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

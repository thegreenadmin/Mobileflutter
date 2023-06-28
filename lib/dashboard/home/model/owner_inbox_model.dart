// To parse this JSON data, do
//
//     final ownerInboxModel = ownerInboxModelFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

OwnerInboxModel ownerInboxModelFromJson(String str) =>
    OwnerInboxModel.fromJson(json.decode(str));

String ownerInboxModelToJson(OwnerInboxModel data) =>
    json.encode(data.toJson());

class OwnerInboxModel {
  dynamic status;
  String? message;
  OwnerInboxData? data;

  OwnerInboxModel({
    this.status,
    this.message,
    this.data,
  });

  OwnerInboxModel copyWith({
    dynamic status,
    String? message,
    OwnerInboxData? data,
  }) =>
      OwnerInboxModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OwnerInboxModel.fromJson(Map<String, dynamic> json) =>
      OwnerInboxModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : OwnerInboxData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class OwnerInboxData {
  dynamic totalCount;
  List<MessageHead>? messageHeads;

  OwnerInboxData({
    this.totalCount,
    this.messageHeads,
  });

  OwnerInboxData copyWith({
    dynamic totalCount,
    List<MessageHead>? messageHeads,
  }) =>
      OwnerInboxData(
        totalCount: totalCount ?? this.totalCount,
        messageHeads: messageHeads ?? this.messageHeads,
      );

  factory OwnerInboxData.fromJson(Map<String, dynamic> json) => OwnerInboxData(
        totalCount: json["total_count"],
        messageHeads: json["message_heads"] == null
            ? []
            : List<MessageHead>.from(
                json["message_heads"]!.map((x) => MessageHead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "message_heads": messageHeads == null
            ? []
            : List<dynamic>.from(messageHeads!.map((x) => x.toJson())),
      };
}

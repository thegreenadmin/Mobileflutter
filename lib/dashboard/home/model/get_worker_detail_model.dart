// To parse this JSON data, do
//
//     final workerDetailResponse = workerDetailResponseFromJson(jsonString);

import 'dart:convert';
import 'model.dart';

WorkerDetailResponse workerDetailResponseFromJson(String str) => WorkerDetailResponse.fromJson(json.decode(str));

String workerDetailResponseToJson(WorkerDetailResponse data) => json.encode(data.toJson());

class WorkerDetailResponse {
    WorkerDetailResponse({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    WorkerDetailData? data;

    WorkerDetailResponse copyWith({
        int? status,
        String? message,
        WorkerDetailData? data,
    }) => 
        WorkerDetailResponse(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory WorkerDetailResponse.fromJson(Map<String, dynamic> json) => WorkerDetailResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : WorkerDetailData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class WorkerDetailData {
    WorkerDetailData({
        this.storeUser,
    });

    StoreUser? storeUser;

    WorkerDetailData copyWith({
        StoreUser? storeUser,
    }) => 
        WorkerDetailData(
            storeUser: storeUser ?? this.storeUser,
        );

    factory WorkerDetailData.fromJson(Map<String, dynamic> json) => WorkerDetailData(
        storeUser: json["store_user"] == null ? null : StoreUser.fromJson(json["store_user"]),
    );

    Map<String, dynamic> toJson() => {
        "store_user": storeUser?.toJson(),
    };
}










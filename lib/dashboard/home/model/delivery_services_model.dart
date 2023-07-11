// To parse this JSON data, do
//
//     final deliveryServicesResponse = deliveryServicesResponseFromJson(jsonString);

import 'dart:convert';

DeliveryServicesResponse deliveryServicesResponseFromJson(String str) =>
    DeliveryServicesResponse.fromJson(json.decode(str));

String deliveryServicesResponseToJson(DeliveryServicesResponse data) =>
    json.encode(data.toJson());

class DeliveryServicesResponse {
  DeliveryServicesResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  DeliveryServicesData? data;

  DeliveryServicesResponse copyWith({
    int? status,
    String? message,
    DeliveryServicesData? data,
  }) =>
      DeliveryServicesResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DeliveryServicesResponse.fromJson(Map<String, dynamic> json) =>
      DeliveryServicesResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : DeliveryServicesData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DeliveryServicesData {
  DeliveryServicesData({
    this.deliveryServices,
  });

  List<DeliveryService>? deliveryServices;

  DeliveryServicesData copyWith({
    List<DeliveryService>? deliveryServices,
  }) =>
      DeliveryServicesData(
        deliveryServices: deliveryServices ?? this.deliveryServices,
      );

  factory DeliveryServicesData.fromJson(Map<String, dynamic> json) =>
      DeliveryServicesData(
        deliveryServices: json["delivery_services"] == null
            ? []
            : List<DeliveryService>.from(json["delivery_services"]!
                .map((x) => DeliveryService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "delivery_services": deliveryServices == null
            ? []
            : List<dynamic>.from(deliveryServices!.map((x) => x.toJson())),
      };
}

class DeliveryService {
  DeliveryService({
    this.deliveryServiceName,
    this.deliveryServiceId,
    this.isSelected = false,
  });

  String? deliveryServiceName;
  String? deliveryServiceId;
  bool isSelected;

  DeliveryService copyWith({
    String? deliveryServiceName,
    String? deliveryServiceId,
    bool? isSelected,
  }) =>
      DeliveryService(
        deliveryServiceName: deliveryServiceName ?? this.deliveryServiceName,
        deliveryServiceId: deliveryServiceId ?? this.deliveryServiceId,
        isSelected: isSelected ?? this.isSelected,
      );

  factory DeliveryService.fromJson(Map<String, dynamic> json) =>
      DeliveryService(
        deliveryServiceName: json["delivery_service_name"],
        deliveryServiceId: json["delivery_service_id"],
      );

  Map<String, dynamic> toJson() => {
        "delivery_service_name": deliveryServiceName,
        "delivery_service_id": deliveryServiceId,
      };
}

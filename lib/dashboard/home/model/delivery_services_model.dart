// To parse this JSON data, do
//
//     final deliveryServicesResponse = deliveryServicesResponseFromJson(jsonString);

import 'dart:convert';

DeliveryServicesResponse deliveryServicesResponseFromJson(String str) => DeliveryServicesResponse.fromJson(json.decode(str));

String deliveryServicesResponseToJson(DeliveryServicesResponse data) => json.encode(data.toJson());

class DeliveryServicesResponse {
  DeliveryServicesResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  DeliveryServicesResponse copyWith({
    int? status,
    String? message,
    Data? data,
  }) =>
      DeliveryServicesResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DeliveryServicesResponse.fromJson(Map<String, dynamic> json) => DeliveryServicesResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.deliveryServices,
  });

  List<DeliveryService>? deliveryServices;

  Data copyWith({
    List<DeliveryService>? deliveryServices,
  }) =>
      Data(
        deliveryServices: deliveryServices ?? this.deliveryServices,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    deliveryServices: json["delivery_services"] == null ? [] : List<DeliveryService>.from(json["delivery_services"]!.map((x) => DeliveryService.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "delivery_services": deliveryServices == null ? [] : List<dynamic>.from(deliveryServices!.map((x) => x.toJson())),
  };
}

class DeliveryService {
  DeliveryService({
    this.id,
    this.name,
    this.isSelected,
  });

  String? id;
  String? name;
  bool? isSelected;

  DeliveryService copyWith({
    String? id,
    String? name,
  }) =>
      DeliveryService(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory DeliveryService.fromJson(Map<String, dynamic> json) => DeliveryService(
    id: json["delivery_service_id"],
    name: json["delivery_service_name"],
  );

  Map<String, dynamic> toJson() => {
    "delivery_service_id": id,
    "delivery_service_name": name,
  };
}

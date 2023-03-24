// To parse this JSON data, do
//     final addWorkerRequest = addWorkerRequestFromJson(jsonString);

import 'dart:convert';

AddWorkerRequest addWorkerRequestFromJson(String str) =>
    AddWorkerRequest.fromJson(json.decode(str));

String addWorkerRequestToJson(AddWorkerRequest data) =>
    json.encode(data.toJson());

class AddWorkerRequest {
  AddWorkerRequest({
    this.storeId,
    this.employeeName,
    this.description,
    this.phone,
    this.phoneCode,
    this.email,
    this.imageUrl,
    this.employeeTimings,
    this.roleId,
  });

  int? storeId;
  String? employeeName;
  String? description;
  String? phone;
  String? phoneCode;
  String? email;
  String? imageUrl;
  List<EmployeeTiming>? employeeTimings;
  int? roleId;

  AddWorkerRequest copyWith({
    int? storeId,
    String? employeeName,
    String? description,
    String? phone,
    String? phoneCode,
    String? email,
    String? imageUrl,
    List<EmployeeTiming>? employeeTimings,
    int? roleId,
  }) =>
      AddWorkerRequest(
        storeId: storeId ?? this.storeId,
        employeeName: employeeName ?? this.employeeName,
        description: description ?? this.description,
        phone: phone ?? this.phone,
        phoneCode: phoneCode ?? this.phoneCode,
        email: email ?? this.email,
        imageUrl: imageUrl ?? this.imageUrl,
        employeeTimings: employeeTimings ?? this.employeeTimings,
        roleId: roleId ?? this.roleId,
      );

  factory AddWorkerRequest.fromJson(Map<String, dynamic> json) =>
      AddWorkerRequest(
        storeId: json["store_id"],
        employeeName: json["employee_name"],
        description: json["description"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        email: json["email"],
        imageUrl: json["image_url"],
        employeeTimings: json["employee_timings"] == null
            ? []
            : List<EmployeeTiming>.from(json["employee_timings"]!
                .map((x) => EmployeeTiming.fromJson(x))),
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "employee_name": employeeName,
        "description": description,
        "phone": phone,
        "phone_code": phoneCode,
        "email": email,
        "image_url": imageUrl,
        "employee_timings": employeeTimings == null
            ? []
            : List<dynamic>.from(employeeTimings!.map((x) => x.toJson())),
        "role_id": roleId,
      };
}

class EmployeeTiming {
  EmployeeTiming({
    this.dayOfWeek,
    this.is24HrsActive,
    this.startTime,
    this.endTime,
  });

  int? dayOfWeek;
  bool? is24HrsActive;
  String? startTime;
  String? endTime;

  EmployeeTiming copyWith({
    int? dayOfWeek,
    bool? is24HrsActive,
    String? startTime,
    String? endTime,
  }) =>
      EmployeeTiming(
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        is24HrsActive: is24HrsActive ?? this.is24HrsActive,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  factory EmployeeTiming.fromJson(Map<String, dynamic> json) => EmployeeTiming(
        dayOfWeek: json["day_of_week"],
        is24HrsActive: json["is_24_hrs_active"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "day_of_week": dayOfWeek,
        "is_24_hrs_active": is24HrsActive,
        "start_time": startTime,
        "end_time": endTime,
      };
}

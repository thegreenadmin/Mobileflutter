// To parse this JSON data, do
//
//     final editWorkerRequest = editWorkerRequestFromJson(jsonString);

import 'dart:convert';

EditWorkerRequest editWorkerRequestFromJson(String str) => EditWorkerRequest.fromJson(json.decode(str));

String editWorkerRequestToJson(EditWorkerRequest data) => json.encode(data.toJson());

class EditWorkerRequest {
  EditWorkerRequest({
    this.storeId,
    this.storeUserId,
    this.description,
    this.employeeTimings,
  });

  int? storeId;
  int? storeUserId;
  String? description;
  List<EmployeeTiming>? employeeTimings;

  EditWorkerRequest copyWith({
    int? storeId,
    int? storeUserId,
    String? description,
    List<EmployeeTiming>? employeeTimings,
  }) =>
      EditWorkerRequest(
        storeId: storeId ?? this.storeId,
        storeUserId: storeUserId ?? this.storeUserId,
        description: description ?? this.description,
        employeeTimings: employeeTimings ?? this.employeeTimings,
      );

  factory EditWorkerRequest.fromJson(Map<String, dynamic> json) => EditWorkerRequest(
    storeId: json["store_id"],
    storeUserId: json["store_user_id"],
    description: json["description"],
    employeeTimings: json["employee_timings"] == null ? [] : List<EmployeeTiming>.from(json["employee_timings"]!.map((x) => EmployeeTiming.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "store_id": storeId,
    "store_user_id": storeUserId,
    "description": description,
    "employee_timings": employeeTimings == null ? [] : List<dynamic>.from(employeeTimings!.map((x) => x.toJson())),
  };
}

class EmployeeTiming {
  EmployeeTiming({
    this.storeUserTimingId,
    this.dayOfWeek,
    this.is24HrsActive,
    this.startTime,
    this.endTime,
    this.status,
  });

  String? storeUserTimingId;
  int? dayOfWeek;
  bool? is24HrsActive;
  String? startTime;
  String? endTime;
  String? status;

  EmployeeTiming copyWith({
    String? storeUserTimingId,
    int? dayOfWeek,
    bool? is24HrsActive,
    String? startTime,
    String? endTime,
    String? status,
  }) =>
      EmployeeTiming(
        storeUserTimingId: storeUserTimingId ?? this.storeUserTimingId,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        is24HrsActive: is24HrsActive ?? this.is24HrsActive,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
      );

  factory EmployeeTiming.fromJson(Map<String, dynamic> json) => EmployeeTiming(
    storeUserTimingId: json["store_user_timing_id"],
    dayOfWeek: json["day_of_week"],
    is24HrsActive: json["is_24_hrs_active"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "store_user_timing_id": storeUserTimingId,
    "day_of_week": dayOfWeek,
    "is_24_hrs_active": is24HrsActive,
    "start_time": startTime,
    "end_time": endTime,
    "status": status,
  };
}

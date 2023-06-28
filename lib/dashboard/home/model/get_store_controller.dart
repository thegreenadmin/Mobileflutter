class GetStoreControllerModel {
  int? status;
  String? message;
  StoreControllerData? data;

  GetStoreControllerModel({this.status, this.message, this.data});

  GetStoreControllerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StoreControllerData.fromJson(json['data']) : null;
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

class StoreControllerData {
  List<Modules>? modules;

  StoreControllerData({this.modules});

  StoreControllerData.fromJson(Map<String, dynamic> json) {
    if (json['modules'] != null) {
      modules = <Modules>[];
      json['modules'].forEach((v) {
        modules!.add(Modules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (modules != null) {
      data['modules'] = modules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modules {
  String? moduleId;
  String? moduleName;
  String? moduleKey;
  List<Controllers>? controllers;

  Modules({this.moduleId, this.moduleName, this.moduleKey, this.controllers});

  Modules.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleName = json['module_name'];
    moduleKey = json['module_key'];
    if (json['controllers'] != null) {
      controllers = <Controllers>[];
      json['controllers'].forEach((v) {
        controllers!.add(Controllers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_id'] = moduleId;
    data['module_name'] = moduleName;
    data['module_key'] = moduleKey;
    if (controllers != null) {
      data['controllers'] = controllers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Controllers {
  String? controllerId;
  String? controllerName;
  String? controllerKey;
  String? controllerDescription;
  bool? isSelected = false;

  Controllers(
      {this.controllerId,
      this.controllerName,
      this.controllerKey,
      this.controllerDescription,
      this.isSelected});

  Controllers.fromJson(Map<String, dynamic> json) {
    controllerId = json['controller_id'];
    controllerName = json['controller_name'];
    controllerKey = json['controller_key'];
    controllerDescription = json['controller_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['controller_id'] = controllerId;
    data['controller_name'] = controllerName;
    data['controller_key'] = controllerKey;
    data['controller_description'] = controllerDescription;
    return data;
  }
}

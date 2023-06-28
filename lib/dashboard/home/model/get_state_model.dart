class GetStatesModel {
  int? status;
  String? message;
  StatesData? data;

  GetStatesModel({this.status, this.message, this.data});

  GetStatesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StatesData.fromJson(json['data']) : null;
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

class StatesData {
  List<StatesList>? states;

  StatesData({this.states});

  StatesData.fromJson(Map<String, dynamic> json) {
    if (json['states'] != null) {
      states = <StatesList>[];
      json['states'].forEach((v) {
        states!.add(StatesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (states != null) {
      data['states'] = states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatesList {
  String? stateId;
  String? stateName;

  StatesList({this.stateId, this.stateName});

  StatesList.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    return data;
  }
}

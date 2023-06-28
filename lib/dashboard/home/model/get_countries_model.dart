class GetCountriesModel {
  int? status;
  String? message;
  CountriesData? data;

  GetCountriesModel({this.status, this.message, this.data});

  GetCountriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CountriesData.fromJson(json['data']) : null;
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

class CountriesData {
  List<CountriesList>? countries;

  CountriesData({this.countries});

  CountriesData.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <CountriesList>[];
      json['countries'].forEach((v) {
        countries!.add(CountriesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountriesList {
  String? countryId;
  String? countryName;

  CountriesList({this.countryId, this.countryName});

  CountriesList.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    return data;
  }
}

// To parse this JSON data, do
//
//     final geocodingResponse = geocodingResponseFromJson(jsonString);

import 'dart:convert';

List<GeocodingResponse> geocodingResponseFromJson(String str) => List<GeocodingResponse>.from(json.decode(str).map((x) => GeocodingResponse.fromJson(x)));

String geocodingResponseToJson(List<GeocodingResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeocodingResponse {
  List<String>? types;
  String? formattedAddress;
  List<AddressComponent>? addressComponents;
  List<dynamic>? postcodeLocalities;
  Geometry? geometry;
  bool? partialMatch;
  String? placeId;

  GeocodingResponse({
    this.types,
    this.formattedAddress,
    this.addressComponents,
    this.postcodeLocalities,
    this.geometry,
    this.partialMatch,
    this.placeId,
  });

  GeocodingResponse copyWith({
    List<String>? types,
    String? formattedAddress,
    List<AddressComponent>? addressComponents,
    List<dynamic>? postcodeLocalities,
    Geometry? geometry,
    bool? partialMatch,
    String? placeId,
  }) =>
      GeocodingResponse(
        types: types ?? this.types,
        formattedAddress: formattedAddress ?? this.formattedAddress,
        addressComponents: addressComponents ?? this.addressComponents,
        postcodeLocalities: postcodeLocalities ?? this.postcodeLocalities,
        geometry: geometry ?? this.geometry,
        partialMatch: partialMatch ?? this.partialMatch,
        placeId: placeId ?? this.placeId,
      );

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) => GeocodingResponse(
    types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    formattedAddress: json["formatted_address"],
    addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
    postcodeLocalities: json["postcode_localities"] == null ? [] : List<dynamic>.from(json["postcode_localities"]!.map((x) => x)),
    geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    partialMatch: json["partial_match"],
    placeId: json["place_id"],
  );

  Map<String, dynamic> toJson() => {
    "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    "formatted_address": formattedAddress,
    "address_components": addressComponents == null ? [] : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
    "postcode_localities": postcodeLocalities == null ? [] : List<dynamic>.from(postcodeLocalities!.map((x) => x)),
    "geometry": geometry?.toJson(),
    "partial_match": partialMatch,
    "place_id": placeId,
  };
}

class AddressComponent {
  List<String>? types;
  String? longName;
  String? shortName;

  AddressComponent({
    this.types,
    this.longName,
    this.shortName,
  });

  AddressComponent copyWith({
    List<String>? types,
    String? longName,
    String? shortName,
  }) =>
      AddressComponent(
        types: types ?? this.types,
        longName: longName ?? this.longName,
        shortName: shortName ?? this.shortName,
      );

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    longName: json["long_name"],
    shortName: json["short_name"],
  );

  Map<String, dynamic> toJson() => {
    "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    "long_name": longName,
    "short_name": shortName,
  };
}

class Geometry {
  Location? location;
  String? locationType;
  Viewport? viewport;
  dynamic bounds;

  Geometry({
    this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  Geometry copyWith({
    Location? location,
    String? locationType,
    Viewport? viewport,
    dynamic bounds,
  }) =>
      Geometry(
        location: location ?? this.location,
        locationType: locationType ?? this.locationType,
        viewport: viewport ?? this.viewport,
        bounds: bounds ?? this.bounds,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    locationType: json["location_type"],
    viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
    bounds: json["bounds"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "location_type": locationType,
    "viewport": viewport?.toJson(),
    "bounds": bounds,
  };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  Viewport copyWith({
    Location? northeast,
    Location? southwest,
  }) =>
      Viewport(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
    southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast?.toJson(),
    "southwest": southwest?.toJson(),
  };
}

import 'dart:convert';

class PoiResponse {
  final List<Poi> results;

  PoiResponse({required this.results});

  factory PoiResponse.fromJson(Map<String, dynamic> json) {
    return PoiResponse(
      results: List<Poi>.from(json['results'].map((x) => Poi.fromJson(x))),
    );
  }
}

class Poi {
  final String name;
  final String address;
  final double lat;
  final double lon;

  Poi({
    required this.name,
    required this.address,
    required this.lat,
    required this.lon,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    return Poi(
      name: json['poi']['name'],
      address: address['freeformAddress'],
      lat: json['position']['lat'],
      lon: json['position']['lon'],
    );
  }
}

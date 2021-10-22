import 'package:junebank/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String vicinity;
  final String placeId;

  Place({this.geometry, this.name, this.vicinity, this.placeId});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['name'],
      vicinity: parsedJson['vicinity'],
      placeId: parsedJson['place_id'],
    );
  }
}

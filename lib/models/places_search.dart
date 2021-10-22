import 'package:junebank/models/placeMainText.dart';

class PlaceSearch {
  final String description;
  final String placeId;
  final StructuredFormatingText structuredFormating;

  PlaceSearch({this.description, this.placeId, this.structuredFormating});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
      description: json['description'],
      placeId: json['place_id'],
      structuredFormating:
          StructuredFormatingText.fromJson(json['structured_formatting']),
    );
  }
}

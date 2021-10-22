import 'package:junebank/models/placeMainText.dart';

class PlaceDetail{
  final String description;
  final String placeId;
  final StructuredFormatingText structuredFormating;


  PlaceDetail({this.description,this.placeId,this.structuredFormating});

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
      description: json['description'],
      placeId: json['place_id'],
      structuredFormating:
          StructuredFormatingText.fromJson(json['structured_formatting']),
    );
  }

}
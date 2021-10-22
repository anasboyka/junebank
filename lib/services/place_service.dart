import 'package:http/http.dart' as http;
import 'package:junebank/models/place.dart';
import 'dart:convert' as convert;

import 'package:junebank/models/places_search.dart';

class PlacesService {
  final key = 'AIzaSyDOugkiihXeNWZfVSY78SJQmCUcnGAzFcc';
  double lati = 3.20688, long = 101.69036, radius = 100500;
  Future<List<PlaceSearch>> getAutocomplete(
      String search, double lat, double lng) async {
    String url =
        ('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&location=$lat,$lng&radius=$radius&strictbounds&key=$key');
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    String url =
        ('https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId');
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResults);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    String url =
        ('https://maps.googleapis.com/maps/api/place/textsearch/json?type=$placeType&fields=formatted_address&location=$lat,$lng&rankby=distance&key=$key');
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    //print('json result $jsonResults');
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

  Future<List<Place>> getBankPlacesText(
      double lat, double lng, String placeSearch) async {
    String url =
        ('https://maps.googleapis.com/maps/api/place/nearbysearch/json?types=establishment&location=$lat,$lng&rankby=distance&type=bank&keyword=$placeSearch&key=$key');
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}

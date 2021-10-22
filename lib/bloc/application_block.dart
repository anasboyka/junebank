import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:junebank/models/geometry.dart';
import 'package:junebank/models/location.dart';
import 'package:junebank/models/place.dart';
import 'package:junebank/models/places_search.dart';
import 'package:junebank/services/geolocator_services.dart';
import 'package:junebank/services/marker_service.dart';
import 'package:junebank/services/place_service.dart';
import 'package:rxdart/rxdart.dart';

class AppliactionBloc with ChangeNotifier {
  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();
  Position currentLocation;
  List<PlaceSearch> searchResults;
  List<Marker> markers = <Marker>[];
  StreamController<Place> selectedLocation = new BehaviorSubject();//StreamController<Place>();
  StreamController<LatLngBounds> bounds = new BehaviorSubject();//StreamController<LatLngBounds>();

  String placeType;
  Place selectedLocationStatic;

  AppliactionBloc() {
    setCurrentLocation();
  }
  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: '',
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm, double lat, double lng) async {
    searchResults = await placesService.getAutocomplete(searchTerm, lat, lng);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng,
          placeType);

      markers = [];
      if (places.length > 0) {
        var newMarker = markerService.createMarkerFromPlace(places[0]);
        markers.add(newMarker);
      }
      print(selectedLocationStatic.name);

      var locationMarker =
          markerService.createMarkerFromPlace(selectedLocationStatic);
      markers.add(locationMarker);

      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedLocation.close();
    //bounds.close();
    super.dispose();
  }
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:junebank/bloc/application_block.dart';
import 'package:junebank/models/place.dart';
import 'package:junebank/services/place_service.dart';

class MarkerService {
  AppliactionBloc appliactionBloc;

  LatLngBounds bounds(Set<Marker> markers) {
    if (markers == null || markers.isEmpty) return null;
    return createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds createBounds(List<LatLng> positions) {
    final southwestLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element);
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);

    // LatLng centerBounds = LatLng(
    //     (northeastLat + southwestLat) / 2, (northeastLon + southwestLon) / 2);
    
    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLon),
      northeast: LatLng(northeastLat, northeastLon),
    );
  }

  Marker createMarkerFromPlace(Place place) {
    var markerId = place.name;
    print(markerId);


    return Marker(
        markerId: MarkerId(markerId),
        draggable: false,
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.vicinity,
        ),
        position:
            LatLng(place.geometry.location.lat, place.geometry.location.lng));
  }
}

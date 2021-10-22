import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:junebank/bloc/application_block.dart';
import 'package:junebank/services/marker_service.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import '../../models/place.dart';

class MapGoogle extends StatefulWidget {
  @override
  _MapGoogleState createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  geolocator.Position _currentPosition;
  LatLng _initialcameraposition = LatLng(37.4219983, -122.084);
  GoogleMapController _controller;
  loc.Location _location = loc.Location();
  String latitude = "loading", longitude = "";
  var userLocation;
  String spatutnya = "3.20688,101.69036";
  String _currentAddress = '';
  final searchform = new TextEditingController();
  double lat = 4.2105, lng = 101.9758;

  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;
  StreamSubscription boundSubscription;
  var applicationBloc;

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel();
    boundSubscription.cancel();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    applicationBloc = Provider.of<AppliactionBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    boundSubscription = applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;

      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
    //_getCurrentLocation();
    getLastLocation();
  }

  Future<geolocator.Position> getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
      print(e.toString());
    }
    return currentLocation;
  }

  void calculateDistance() async {
    getLocation().then((position) async {
      userLocation = position;

      final double myPositionLat = userLocation.latitude;
      final double myPositionLong = userLocation.longitude;

      final double TPLat = 51.5148731;
      final double TPLong = -0.1923663;
      final distanceInMetres = await geolocator.Geolocator.distanceBetween(
              myPositionLat, myPositionLong, TPLat, TPLong) /
          1000;

      print(distanceInMetres);
    });
  }

  void getLastLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getLastKnownPosition(
            forceAndroidLocationManager: true);
    setState(() {
      _currentPosition = position;
      lat = position.latitude;
      lng = position.longitude;
    });
    _getAddressFromLatLng();
    //print('loc ${position.latitude}');
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name},${place.thoroughfare},${place.subLocality} ,${place.postalCode} ,${place.administrativeArea} ";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext contextt) {
    final applicationBloc = Provider.of<AppliactionBloc>(contextt);
    return WillPopScope(
      onWillPop: () async {
        await locationSubscription.cancel();
        await boundSubscription.cancel();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff47838E),
            shadowColor: Colors.transparent,
            title: Text(
              'FIND NEARBY ATM/BANK',
              style: TextStyle(color: Colors.white),
            ),
            //centerTitle: true,
          ),
          body: (applicationBloc == null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey[300]),
                            ),
                          ),
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            myLocationButtonEnabled: true,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(3.20688, 101.69036), zoom: 17),
                            mapType: MapType.normal,
                            markers: Set<Marker>.of(applicationBloc.markers),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                            myLocationEnabled: true,
                            padding: EdgeInsets.only(top: 100),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Stack(
                            children: [
                              ((applicationBloc.searchResults != null &&
                                      applicationBloc.searchResults.length !=
                                          0))
                                  ? Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xffDBDBDB)),
                                          left: BorderSide(
                                              color: Color(0xffDBDBDB)),
                                        ),
                                      ),
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(top: 50),
                                          shrinkWrap: true,
                                          itemCount: applicationBloc
                                              .searchResults.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    applicationBloc
                                                        .searchResults[index]
                                                        .structuredFormating
                                                        .mainText,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  leading: Icon(
                                                    Icons.location_pin,
                                                    color: Colors.blue,
                                                  ),
                                                  subtitle: Text(applicationBloc
                                                      .searchResults[index]
                                                      .structuredFormating
                                                      .secondaryText),
                                                  onTap: () {
                                                    applicationBloc
                                                        .setSelectedLocation(
                                                            applicationBloc
                                                                .searchResults[
                                                                    index]
                                                                .placeId);
                                                    searchform.text =
                                                        applicationBloc
                                                            .searchResults[
                                                                index]
                                                            .structuredFormating
                                                            .mainText;
                                                  },
                                                ),
                                                Divider(
                                                  color: Color(0xffDBDBDB),
                                                  thickness: 1,
                                                  height: 0,
                                                )
                                              ],
                                            );
                                          }),
                                    )
                                  : Container(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 3),
                                      blurRadius: 10.0,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    return applicationBloc.searchPlaces(
                                        value, lat, lng);
                                  },
                                  controller: searchform,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Manual Search',
                                    prefixIcon: Icon(Icons.location_pin),
                                    suffixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'current Location : ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_currentAddress),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Find Nearby atm/bank',
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Wrap(
                          spacing: 8,
                          children: [
                            FilterChip(
                              label: Text('Nearest ATM'),
                              onSelected: (val) {
                                return applicationBloc.togglePlaceType(
                                    'atm', val);
                              },
                              selected: applicationBloc.placeType == 'atm',
                              selectedColor: Colors.blue[300],
                            ),
                            FilterChip(
                              label: Text('Nearest Bank'),
                              onSelected: (val) {
                                return applicationBloc.togglePlaceType(
                                    'bank', val);
                              },
                              selected: applicationBloc.placeType == 'bank',
                              selectedColor: Colors.blue[300],
                            ),
                            // FilterChip(
                            //   label: Text('Bank Rakyat'),
                            //   onSelected: (val) {
                            //     return applicationBloc.togglePlaceType('bank', val);
                            //   },
                            //   selected: applicationBloc.placeType == 'bank',
                            //   selectedColor: Colors.blue[300],
                            // ),
                            // FilterChip(
                            //   label: Text('CIMB Bank'),
                            //   onSelected: (val) {
                            //     return applicationBloc.togglePlaceType('bank', val);
                            //   },
                            //   selected: applicationBloc.placeType == 'bank',
                            //   selectedColor: Colors.blue[300],
                            // ),
                            // FilterChip(
                            //   label: Text('Bank Islam'),
                            //   onSelected: (val) {
                            //     return applicationBloc.togglePlaceType('bank', val);
                            //   },
                            //   selected: applicationBloc.placeType == 'bank',
                            //   selectedColor: Colors.blue[300],
                            // ),
                            // FilterChip(
                            //   label: Text('AmBank'),
                            //   onSelected: (val) {
                            //     return applicationBloc.togglePlaceType('bank', val);
                            //   },
                            //   selected: applicationBloc.placeType == 'bank',
                            //   selectedColor: Colors.blue[300],
                            // ),
                            // FilterChip(
                            //   label: Text('HSBC Bank'),
                            //   onSelected: (val) {
                            //     return applicationBloc.togglePlaceType('bank', val);
                            //   },
                            //   selected: applicationBloc.placeType == 'bank',
                            //   selectedColor: Colors.blue[300],
                            // ),
                            // FilterChip(
                            //   label: Text('Affin Bank'),
                            //   onSelected: (val) {
                            //     return applicationBloc.togglePlaceType('bank', val);
                            //   },
                            //   selected: applicationBloc.placeType == 'bank',
                            //   selectedColor: Colors.blue[300],
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 17.0)));
  }
}

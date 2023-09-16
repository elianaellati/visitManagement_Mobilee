import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GpsController{
  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "";
  String lat = "";
  checkGps() async {
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (!serviceStatus) {
      print("GPS Service is not enabled, turn on GPS location");
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("REQUESTING LOCATION PERMISSION");
    }

    if (permission == LocationPermission.whileInUse) {
      hasPermission = true;
    }

    if (hasPermission) {
      await getLocation();
    }
  }
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(position.longitude);
    print(position.latitude);

    long = position.longitude.toString();
    lat = position.latitude.toString();

    print("Longitude:  $long ");
    print("Latitude: $lat");
    print("Request successful");

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      print(position.longitude);
      print(position.latitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();
    });
  }


}
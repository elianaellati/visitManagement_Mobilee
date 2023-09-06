import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class openMap extends StatefulWidget {
  final double longitude;
  final double latitude;

  openMap(this.latitude, this.longitude);

  @override
  State<openMap> createState() => OpenMapState();
}

class OpenMapState extends State<openMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customer Location'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude), // Use widget.latitude and widget.longitude
            zoom: 12,
          ),
        ),
      ),
    );
  }
}

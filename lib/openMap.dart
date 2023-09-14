
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:visitManagement_Mobilee/formTitle.dart';

class openMap extends StatefulWidget {
  final double longitude;
  final double latitude;
  final String userLatitude;
  final String userLongitude;


  openMap(this.latitude, this.longitude, this.userLatitude, this.userLongitude);


  @override
  State<openMap> createState() => OpenMapState();
}

class OpenMapState extends State<openMap> {
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];




  @override
  void initState() {
    super.initState();
    makeLines();
  }

  @override
  Widget build(BuildContext context) {
    double userLatitudeAsDouble = double.tryParse(widget.userLatitude) ?? 0.0;

    double userLongitudeAsDouble = double.tryParse(widget.userLongitude) ?? 0.0;
    return MaterialApp(
      title: 'Google Maps Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customer Location'),

        ),
        body: GoogleMap(
          polylines: Set<Polyline>.of(polylines.values),
          initialCameraPosition: CameraPosition(
            target: LatLng(userLatitudeAsDouble, userLongitudeAsDouble),
            zoom: 16,
          ),

        ),
      ),
    );
  }

  void makeLines() async {
    try {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCQjNwhMS3jvtkUsP2gyqACO8s0uYXOtSE',
        PointLatLng(double.parse(widget.userLatitude), double.parse(widget.userLongitude)),
        PointLatLng(widget.latitude, widget.longitude),


        travelMode: TravelMode.driving,

      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        addPolyLine();
      } else {
        print('No points found in the route.');
      }
    } catch (e) {
      print('Error in makeLines: $e');
    }
  }


  void addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5, // Width of the polyline
    );
    polylines[id] = polyline;
    setState(() {});
  }
}


// class openMap extends StatefulWidget {
//   final double longitude;
//   final double latitude;
//   final String userLatitude;
//   final String userLongitude;
//
//   openMap(this.latitude, this.longitude,this.userLatitude,this.userLongitude);
//
//   @override
//   State<openMap> createState() => OpenMapState();
// }
//
// class OpenMapState extends State<openMap> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Maps Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Customer Location'),
//         ),
//         body: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(widget.latitude, widget.longitude),
//             // Use widget.latitude and widget.longitude
//             zoom: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

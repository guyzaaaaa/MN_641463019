import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:csit2023/menu.dart';

class GPSTracking extends StatefulWidget {
  @override
  _GPSTrackingState createState() => _GPSTrackingState();
}

class _GPSTrackingState extends State<GPSTracking> {
  GoogleMapController? mapController;
  List<Marker> markers = [];
  LatLngBounds? bounds;
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/getlocation.php'));
      if (response.statusCode == 200) {
        List<dynamic> locations = json.decode(response.body);
        List<LatLng> points = [];
        for (var location in locations) {
          points.add(LatLng(double.parse(location['Latitude'].trim()), double.parse(location['Longitude'].trim())));
        }
        setState(() {
          markers = locations.map((location) {
            return Marker(
              markerId: MarkerId(location['PlaceCode'].toString()),
              position: LatLng(double.parse(location['Latitude'].trim()), double.parse(location['Longitude'].trim())),
              infoWindow: InfoWindow(
                title: location['PlaceName'],
              ),
            );
          }).toList();
          
          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: points,
            color: Colors.blue, // สีของเส้น Polyline
            width: 3, // ความกว้างของเส้น Polyline
          ));

          bounds = _calculateBounds(markers);
        });
      } else {
        throw Exception('การโหลดตำแหน่งผิดพลาด');
      }
    } catch (error) {
      print('Error fetching locations: $error');
    }
  }

  LatLngBounds _calculateBounds(List<Marker> markers) {
    double minLat = markers[0].position.latitude;
    double minLng = markers[0].position.longitude;
    double maxLat = markers[0].position.latitude;
    double maxLng = markers[0].position.longitude;

    for (Marker marker in markers) {
      if (marker.position.latitude < minLat) {
        minLat = marker.position.latitude;
      }
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.latitude > maxLat) {
        maxLat = marker.position.latitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainMenu(),
            ));
          },
        ),
        title: Text('จุดท่องเที่ยว'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(13.7563, 100.5018),
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
            if (bounds != null) {
              controller.animateCamera(CameraUpdate.newLatLngBounds(bounds!, 50));
            }
          });
        },
        markers: Set<Marker>.of(markers),
        polylines: polylines,
      ),
    );
  }
}

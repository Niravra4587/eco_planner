import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapWithRoutes extends StatefulWidget {
  final double startLat = 37.34;
  final double startLon = -121.89;
  final double endLat;
  final double endLon;

  const MapWithRoutes({
    required this.endLat,
    required this.endLon,
  });

  @override
  _MapWithRoutesState createState() => _MapWithRoutesState();
}

class _MapWithRoutesState extends State<MapWithRoutes> {
  List<Polyline> _routePolylines = [];
  List<Marker> _routeMarkers = [];
  List<Map<String, dynamic>> _routeDetails = [];
  final double emissionFactor = 0.120; // Petrol car (kg CO₂/km)

  @override
  void initState() {
    super.initState();
    fetchRoutesAndRender();
  }

  Future<void> fetchRoutesAndRender() async {
    final url = 'https://api.tomtom.com/maps/orbis/routing/calculateRoute/${widget.startLat},${widget.startLon}:${widget.endLat},${widget.endLon}/json?apiVersion=2&key=AuCpuHKc6CfIarUsu2HSYnzPNmFQv7iX&traffic=historical&maxAlternatives=3&sectionType=traffic&extendedRouteRepresentation=distance&extendedRouteRepresentation=travelTime';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routes = data['routes'];

      List<Polyline> polylines = [];
      List<Marker> markers = [];
      List<Map<String, dynamic>> routeDetails = [];

      for (var route in routes) {
        // Extract route geometry
        final points = route['legs'][0]['points'];
        List<LatLng> coordinates = points
            .map<LatLng>((point) => LatLng(point['latitude'], point['longitude']))
            .toList();

        // Calculate CO₂ emissions
        double distanceInKm = route['summary']['lengthInMeters'] / 1000.0;
        double emissions = distanceInKm * emissionFactor;

        // Route details (add other details like time, distance, etc.)
        routeDetails.add({
          'route': route,
          'emissions': emissions,
          'distance': distanceInKm,
          'time': route['summary']['travelTimeInSeconds'] / 60, // Time in minutes
        });

        // Create a polyline for the route
        polylines.add(
          Polyline(
            points: coordinates,
            strokeWidth: 6.0,
            color: Colors.green,
          ),
        );

        // Add a marker with CO₂ emission info at the midpoint of the route
        if (coordinates.isNotEmpty) {
          final midpoint = coordinates[(coordinates.length / 2).floor()];
          markers.add(
            Marker(
              width: 80.0,
              height: 50.0,
              point: midpoint,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Text(
                  'CO₂: ${emissions.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
              ),
            ),
          );
        }
      }

      // Add start and end markers
      markers.addAll([
        Marker(
          width: 200.0,
          height: 50.0,
          point: LatLng(widget.startLat, widget.startLon),
          child: Icon(Icons.start),
        ),
        Marker(
          width: 200.0,
          height: 50.0,
          point: LatLng(widget.endLat, widget.endLon),
          child: Icon(Icons.navigation_sharp),
        ),
      ]);

      // Sort the route details based on CO₂ emissions (ascending order)
      routeDetails.sort((a, b) => a['emissions'].compareTo(b['emissions']));

      setState(() {
        _routePolylines = polylines;
        _routeMarkers = markers;
        _routeDetails = routeDetails;
      });
    } else {
      print('Failed to fetch routes: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Routes and Emissions')),
      body: Column(
        children: [
          // Map Container
          Container(
            height: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(widget.startLat, widget.startLon),
                zoom: 15.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: _routePolylines,
                ),
                MarkerLayer(
                  markers: _routeMarkers,
                ),
              ],
            ),
          ),
          // Details Container (Sorted by CO₂ emissions)
          Expanded(
            child: ListView.builder(
              itemCount: _routeDetails.length,
              itemBuilder: (context, index) {
                final routeDetail = _routeDetails[index];
                final emissions = routeDetail['emissions'];
                final distance = routeDetail['distance'];
                final time = routeDetail['time'];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Route ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Distance: ${distance.toStringAsFixed(2)} km\n'
                          'Time: ${time.toStringAsFixed(2)} min\n'
                          'CO₂ Emissions: ${emissions.toStringAsFixed(2)} kg',
                    ),
                    leading: Icon(Icons.route),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

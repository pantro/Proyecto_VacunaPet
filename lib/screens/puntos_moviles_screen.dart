import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PuntosMovilesScreen extends StatefulWidget {
  const PuntosMovilesScreen({super.key});
  @override
  _PuntosMovilesScreenState createState() => _PuntosMovilesScreenState();
}

class _PuntosMovilesScreenState extends State<PuntosMovilesScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late BitmapDescriptor _autoIcon;
  Timer? _timer;
  List<LatLng> _routePoints = [];

  // Tus puntos fijos
  final List<LatLng> _stops = [
    LatLng(-16.418406, -71.475417),
    LatLng(-16.407764, -71.478325),
    LatLng(-16.413690, -71.494548),
    LatLng(-16.410015, -71.495162),
    LatLng(-16.406820, -71.504452),
    LatLng(-16.413021, -71.501057),
  ];

  int _currentSegment = 0;
  int _polyIndex = 0;
  late LatLng _autoPos;

  @override
  void initState() {
    super.initState();
    _autoPos = _stops[0];
    _loadAutoIcon().then((_) => _loadRouteAndAnimate());
  }

  Future<void> _loadAutoIcon() async {
    _autoIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32,32)),
      'assets/images/auto.png',
    );
  }

  Future<void> _loadRouteAndAnimate() async {
    // Pide la ruta entre el punto actual y el siguiente
    final origin = _stops[_currentSegment];
    final dest   = _stops[(_currentSegment+1)%_stops.length];
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${dest.latitude},${dest.longitude}'
        '&key=TU_DIRECTIONS_API_KEY';

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);
    final points = PolylinePoints()
        .decodePolyline(data['routes'][0]['overview_polyline']['points']);

    _routePoints = points.map((p) => LatLng(p.latitude, p.longitude)).toList();

    // Dibuja la ruta en el mapa
    _polylines.add(Polyline(
      polylineId: const PolylineId('route'),
      points: _routePoints,
      color: Colors.blue,
      width: 4,
    ));

    setState(() {});
    _startAutoAlongRoute();
  }

  void _startAutoAlongRoute() {
    _polyIndex = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_polyIndex < _routePoints.length) {
        _autoPos = _routePoints[_polyIndex++];
      } else {
        // Llegó al final de este segmento: pasa al siguiente
        _currentSegment = (_currentSegment+1)%_stops.length;
        _loadRouteAndAnimate(); // recarga ruta
      }
      _updateMarkers();
      _mapController.animateCamera(CameraUpdate.newLatLng(_autoPos));
    });
  }

  void _updateMarkers() {
    final m = <Marker>{
      // Puntos fijos
      for (var i = 0; i < _stops.length; i++)
        Marker(
          markerId: MarkerId('stop_$i'),
          position: _stops[i],
          infoWindow: InfoWindow(title: 'Punto Fijo ${i+1}'),
        ),
      // Auto
      Marker(
        markerId: const MarkerId('auto'),
        position: _autoPos,
        icon: _autoIcon,
      ),
    };
    setState(() {
      _markers
        ..clear()
        ..addAll(m);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController c) {
    _mapController = c;
    _updateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos Móviles')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _stops[0], zoom: 14),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
      ),
    );
  }
}

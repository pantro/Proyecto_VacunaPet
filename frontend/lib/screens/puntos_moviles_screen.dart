import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../graphql/graphql_config.dart'; // asegúrate de tener graphQLClient
import '../graphql/location_subscription.dart';

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
  

  // Tus puntos fijos
  final List<LatLng> _stops = [
    LatLng(-16.418406, -71.475417),
    LatLng(-16.407764, -71.478325),
    //LatLng(-16.413690, -71.494548),
    //LatLng(-16.410015, -71.495162),
    //LatLng(-16.406820, -71.504452),
    //LatLng(-16.413021, -71.501057),
  ];

  late LatLng _autoPos;

  @override
  void initState() {
    super.initState();
    _autoPos = _stops[0];

    //_loadAutoIcon().then((_) {
    _updateMarkers();

    int markerCount = 0; // contador para IDs únicos

    LocationSubscriptionManager(
      client: graphQLClient.value,
      onLocationUpdate: (lat, lng) {
        final newMarker = Marker(
          markerId: MarkerId('dynamic_${markerCount++}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: 'Ubicación #$markerCount'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );

        setState(() {
          _markers.add(newMarker);
          _mapController.animateCamera(CameraUpdate.newLatLng(newMarker.position));
        });

        print('🟢 Nuevo marcador agregado en: $lat, $lng');
      },
    ).start();
    //});
  }

  Future<void> _loadAutoIcon() async {
    _autoIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32,32)),
      'assets/images/auto.png',
    );
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
      /*Marker(
        markerId: const MarkerId('auto'),
        position: _autoPos,
        icon: _autoIcon,
      ),*/
    };
    setState(() {
      _markers
        ..clear()
        ..addAll(m);
    });
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed),
        onPressed: () {
          _mapController.animateCamera(CameraUpdate.newLatLng(_autoPos));
        },
      ),
    );
  }
}

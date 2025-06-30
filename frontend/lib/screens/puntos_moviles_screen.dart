// lib/screens/puntos_moviles_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacunapet/graphql/location_send_mutation.dart';
import '../graphql/graphql_config.dart';
import '../graphql/location_subscription.dart';
import '../services/device_id_service.dart';

class PuntosMovilesScreen extends StatefulWidget {
  const PuntosMovilesScreen({super.key});
  @override
  _PuntosMovilesScreenState createState() => _PuntosMovilesScreenState();
}

class _PuntosMovilesScreenState extends State<PuntosMovilesScreen> {
  late GoogleMapController _mapController;
  final Map<String, Marker> _userMarkers = {};
  final Set<Polyline> _polylines = {};
  late String currentUserId;
  final List<LatLng> _stops = [
    LatLng(-16.418406, -71.475417),
    LatLng(-16.407764, -71.478325),
  ];

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    currentUserId = await getOrCreateUserId(); // obtiene el ID único del dispositivo
    _setupInitialPosition();
    _updateFixedMarkers();

    LocationSubscriptionManager(
      client: graphQLClient.value,
      onLocationUpdate: (userId, lat, lng) {
        final isCurrentUser = userId == currentUserId;
        final marker = Marker(
          markerId: MarkerId(userId),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: isCurrentUser ? 'Mi ubicación' : 'Usuario $userId'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isCurrentUser ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
          ),
        );

        setState(() {
          _userMarkers[userId] = marker;
        });

        if (isCurrentUser) {
          _mapController.animateCamera(CameraUpdate.newLatLng(marker.position));
        }

        print('🟢 [$userId] Nueva ubicación: $lat, $lng');
      },
    ).start();

    _startSendingLocation();
  }

  void _startSendingLocation() {
    Timer.periodic(const Duration(seconds: 60), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        await sendLocation(
          graphQLClient.value,
          currentUserId,
          pos.latitude,
          pos.longitude,
        );
      } catch (e) {
        print('⚠️ Error obteniendo posición para enviar: $e');
      }
    });
  }


  Future<void> _setupInitialPosition() async {
    print("**********************************************************************************");
    print("entro aquiiiiiiiiiiiiiiiiiiiiiiiiii");
    print("**********************************************************************************");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('🛑 El GPS está desactivado.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('🛑 Permiso de ubicación denegado.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('🛑 Permiso de ubicación denegado permanentemente.');
      return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final myMarker = Marker(
      markerId: MarkerId(currentUserId),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(title: 'Mi posición inicial'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _userMarkers[currentUserId] = myMarker;
    });

    // Centra el mapa en tu posición
    _mapController.animateCamera(CameraUpdate.newLatLng(myMarker.position));
  }


  void _updateFixedMarkers() {
    for (var i = 0; i < _stops.length; i++) {
      final marker = Marker(
        markerId: MarkerId('stop_$i'),
        position: _stops[i],
        infoWindow: InfoWindow(title: 'Punto Fijo ${i + 1}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      _userMarkers['stop_$i'] = marker;
    }
  }

  void _onMapCreated(GoogleMapController c) {
    _mapController = c;
    setState(() {}); // Para refrescar marcadores
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos Móviles')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _stops[0], zoom: 14),
        markers: _userMarkers.values.toSet(),
        polylines: _polylines,
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.gps_fixed),
        onPressed: () {
          final marker = _userMarkers[currentUserId];
          if (marker != null) {
            _mapController.animateCamera(CameraUpdate.newLatLng(marker.position));
          }
        },
      ),
    );
  }
}

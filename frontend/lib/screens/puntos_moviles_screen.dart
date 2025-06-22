// lib/screens/puntos_moviles_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../graphql/graphql_config.dart';
import '../graphql/location_subscription.dart';

class PuntosMovilesScreen extends StatefulWidget {
  const PuntosMovilesScreen({super.key});
  @override
  _PuntosMovilesScreenState createState() => _PuntosMovilesScreenState();
}

class _PuntosMovilesScreenState extends State<PuntosMovilesScreen> {
  late GoogleMapController _mapController;
  final Map<String, Marker> _userMarkers = {};
  final Set<Polyline> _polylines = {};
  final String currentUserId = "usuario123"; // ← cambia esto por tu lógica real
  final List<LatLng> _stops = [
    LatLng(-16.418406, -71.475417),
    LatLng(-16.407764, -71.478325),
  ];

  @override
  void initState() {
    super.initState();
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

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PuntosFijosScreen extends StatefulWidget {
  const PuntosFijosScreen({super.key});

  @override
  _PuntosFijosScreenState createState() => _PuntosFijosScreenState();
}

class _PuntosFijosScreenState extends State<PuntosFijosScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {}; // Para los marcadores

  // Coordenadas de los puntos fijos en Paucarpata
  static const LatLng _puntoFijo1 = LatLng(-16.418406, -71.475417);
  static const LatLng _puntoFijo2 = LatLng(-16.407764, -71.478325);
  static const LatLng _puntoFijo3 = LatLng(-16.413690, -71.494548);
  static const LatLng _puntoFijo4 = LatLng(-16.410015, -71.495162);
  static const LatLng _puntoFijo5 = LatLng(-16.406820, -71.504452);
  static const LatLng _puntoFijo6 = LatLng(-16.413021, -71.501057);

  @override
  void initState() {
    super.initState();
    // Inicializa cualquier cosa que necesites
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Cambiar la posición de la cámara para centrarse en el primer punto
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_puntoFijo1, 14.0),
    );

    setState(() {
      // Agregamos los marcadores
      _markers.add(
        Marker(
          markerId: MarkerId("punto_fijo_1"),
          position: _puntoFijo1,
          infoWindow: InfoWindow(title: "Punto Fijo 1"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("punto_fijo_2"),
          position: _puntoFijo2,
          infoWindow: InfoWindow(title: "Punto Fijo 2"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("punto_fijo_3"),
          position: _puntoFijo3,
          infoWindow: InfoWindow(title: "Punto Fijo 3"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("punto_fijo_4"),
          position: _puntoFijo4,
          infoWindow: InfoWindow(title: "Punto Fijo 4"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("punto_fijo_5"),
          position: _puntoFijo5,
          infoWindow: InfoWindow(title: "Punto Fijo 5"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("punto_fijo_6"),
          position: _puntoFijo6,
          infoWindow: InfoWindow(title: "Punto Fijo 6"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos Fijos en Paucarpata')),
      body: Column(
        children: [
          // Cuadro con descripción
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Puntos Fijos en Paucarpata',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'En estos puntos se realiza la vacunación contra la rabia para mascotas mayores de 4 meses de edad.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Mapa con los puntos fijos
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: _puntoFijo1, // Mapa centrado en el primer punto
                zoom: 14.0,
              ),
              markers: _markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

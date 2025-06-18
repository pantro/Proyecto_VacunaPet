import 'package:flutter/material.dart';
import 'puntos_fijos_screen.dart';
import 'puntos_moviles_screen.dart';

class SectoresScreen extends StatelessWidget {
  const SectoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sectores de Vacunación',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PuntosFijosScreen(),
                  ),
                );
              },
              child: const Text('Puntos Fijos'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PuntosMovilesScreen(),
                  ),
                );
              },
              child: const Text('Puntos Móviles'),
            ),
          ],
        ),
      ),
    );
  }
}

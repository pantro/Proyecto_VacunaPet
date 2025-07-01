// device_id_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Devuelve un ID persistente único por instalación del app.
/// Si no existe, genera un UUID nuevo y lo guarda localmente.
Future<String> getOrCreateUserId() async {
  final prefs = await SharedPreferences.getInstance();
  
  await prefs.remove('userId');

  String? userId = prefs.getString('userId');

  if (userId == null || userId == 'UP1A.231005.007' || userId == 'TE1A.220922.010' || userId.startsWith('unknown')) {
    userId = const Uuid().v4(); // ← genera un UUID único
    await prefs.setString('userId', userId);
  }
  print("****************   userId  *********************");
  print(userId);
  print("************************************************");
  return userId;
}

abstract class LocationEvent {}

class LocationReceived extends LocationEvent {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationReceived(this.latitude, this.longitude, this.timestamp);
}

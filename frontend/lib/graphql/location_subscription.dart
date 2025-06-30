// lib/graphql/location_subscription.dart
import 'package:graphql_flutter/graphql_flutter.dart';

final String locationSubscription = r'''
subscription {
  locationUpdated {
    userId
    latitude
    longitude
    timestamp
  }
}
''';

class LocationSubscriptionManager {
  final void Function(String userId, double lat, double lng) onLocationUpdate;
  final GraphQLClient client;

  LocationSubscriptionManager({
    required this.client,
    required this.onLocationUpdate,
  });

  void start() {
    print('[********* LocationSubscriptionManager] Iniciando suscripción...');

    final Stream<QueryResult> stream = client.subscribe(
      SubscriptionOptions(document: gql(locationSubscription)),
    );

    stream.listen((result) {
      print('[********* LocationSubscriptionManager] Resultado recibido');

      if (result.hasException) {
        print('[Error] ${result.exception.toString()}');
        return;
      }

      if (result.data != null) {
        final data = result.data!['locationUpdated'];
        if (data != null) {
          final String userId = data['userId'];
          final double lat = (data['latitude'] as num).toDouble();
          final double lng = (data['longitude'] as num).toDouble();

          print('[********* Data] userId: $userId, lat: $lat, lng: $lng');

          onLocationUpdate(userId, lat, lng);
        } else {
          print('[********* Info] data["locationUpdated"] es null');
        }
      } else {
        print('[********* Info] result.data es null');
      }
    });
  }
}

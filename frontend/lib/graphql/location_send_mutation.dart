import 'package:graphql_flutter/graphql_flutter.dart';

const String sendLocationMutation = r'''
mutation SendLocation($userId: String!, $latitude: Float!, $longitude: Float!) {
  createLocation(input: {
    userId: $userId,
    latitude: $latitude,
    longitude: $longitude
  }) {
    id
    timestamp
  }
}
''';

Future<void> sendLocation(
  GraphQLClient client,
  String userId,
  double lat,
  double lng,
) async {
  final result = await client.mutate(MutationOptions(
    document: gql(sendLocationMutation),
    variables: {
      'userId': userId,
      'latitude': lat,
      'longitude': lng,
    },
  ));

  if (result.hasException) {
    print('❌ Error al enviar ubicación: ${result.exception.toString()}');
  } else {
    print("*********************************************");
    print('📤 Ubicación enviada: $lat, $lng');
    print("*********************************************");
  }
}

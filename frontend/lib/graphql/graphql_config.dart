import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';


final httpLink = HttpLink(dotenv.env['GRAPHQL_HTTP_URL']!);

final wsLink = WebSocketLink(
  dotenv.env['GRAPHQL_WS_URL']!,
  config: SocketClientConfig(
    autoReconnect: true,
    inactivityTimeout: Duration(minutes: 10),
  ),
);

final link = Link.split(
  (request) => request.isSubscription,
  wsLink,
  httpLink,
);

ValueNotifier<GraphQLClient> graphQLClient = ValueNotifier(
  GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
  ),
);

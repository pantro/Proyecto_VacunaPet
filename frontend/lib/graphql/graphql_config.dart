import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';


final httpLink = HttpLink('http://10.0.2.2:3000/graphql');

final wsLink = WebSocketLink(
  'ws://10.0.2.2:3000/graphql',
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

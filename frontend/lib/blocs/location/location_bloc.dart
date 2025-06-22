import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState([])) {
    on<LocationReceived>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.locations)
        ..add({
          'lat': event.latitude,
          'lng': event.longitude,
          'timestamp': event.timestamp.toIso8601String()
        });
      emit(LocationState(updatedList));
    });
  }
}

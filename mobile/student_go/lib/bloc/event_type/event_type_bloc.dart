import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';

part 'event_type_event.dart';
part 'event_type_state.dart';

class EventTypeBloc extends Bloc<EventTypeEvent, EventTypeState> {
  final EventTypeRepository eventTypeRepository;
  EventTypeBloc(this.eventTypeRepository) : super(EventTypeInitial()) {
    on<EventTypeEvent>(_fetchEventTypes);
  }

  void _fetchEventTypes(
      EventTypeEvent event, Emitter<EventTypeState> emit) async {
    emit(EventTypeLoading());
    try {
      final response = await eventTypeRepository.getAllEventTypes();
      emit(EventTypeSuccess(response));
    } catch (e) {
      emit(EventTypeError("An unexpected error occurred"));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final EventRepository eventRepository;
  EventListBloc(this.eventRepository) : super(EventListInitial()) {
    on<FetchEventListEvent>(_fetchEventList);
  }

  void _fetchEventList(
      FetchEventListEvent event, Emitter<EventListState> emit) async {
    emit(EventListLoading());
    try {
      final response =
          await eventRepository.getUpcomingEventsLimited(event.city);
      emit(EventListSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        emit(TokenNotValidState());
      } else {
        emit(EventListError("An unespected error occurred"));
      }
    }
  }
}

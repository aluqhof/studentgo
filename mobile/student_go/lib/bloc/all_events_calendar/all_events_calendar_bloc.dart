import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/repository/event/event_repository.dart';

part 'all_events_calendar_event.dart';
part 'all_events_calendar_state.dart';

class AllEventsCalendarBloc
    extends Bloc<AllEventsCalendarEvent, AllEventsCalendarState> {
  final EventRepository eventRepository;
  AllEventsCalendarBloc(this.eventRepository)
      : super(AllEventsCalendarInitial()) {
    on<FetchAllEventsCalendar>(_fetchAllEvents);
  }

  void _fetchAllEvents(FetchAllEventsCalendar event,
      Emitter<AllEventsCalendarState> emit) async {
    emit(AllEventsCalendarLoading());
    try {
      final response = await eventRepository.getAllEvents(event.cityName);
      emit(AllEventsCalendarSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidState());
        }
        emit(AllEventsEntityException(e, e.title!));
      } else {
        emit(AllEventsCalendarError("An unespected error occurred"));
      }
    }
  }
}

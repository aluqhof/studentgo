import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/event_details_response/event_details_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';

part 'event_details_event.dart';
part 'event_details_state.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository eventRepository;
  EventDetailsBloc(this.eventRepository) : super(EventDetailsInitial()) {
    on<FetchEventDetails>(_fetchEventDetails);
  }

  void _fetchEventDetails(
      FetchEventDetails event, Emitter<EventDetailsState> emit) async {
    emit(EventDetailsLoading());
    try {
      final response = await eventRepository.getEventDetails(event.eventId);
      emit(EventDetailsSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateEventDetails());
        }
        emit(EventDetailsEntityException(e, e.title!));
      } else {
        emit(EventDetailsError("An unespected error occurred"));
      }
    }
  }
}

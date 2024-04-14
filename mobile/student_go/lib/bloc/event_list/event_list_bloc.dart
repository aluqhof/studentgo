import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final EventRepository eventRepository;
  EventListBloc(this.eventRepository) : super(EventListInitial()) {
    on<FetchUpcomingListEvent>(_fetchUpcomingList);
    on<FetchAccordingListEvent>(_fetchAccordingList);
    on<FetchEventTypeListEvent>(_fetchEventTypeList);
    on<FetchUpcomingListSearchableEvent>(_fetchUpcomingSearchableList);
  }

  void _fetchUpcomingList(
      FetchUpcomingListEvent event, Emitter<EventListState> emit) async {
    emit(EventListLoading());
    try {
      final response = await eventRepository.getUpcomingEventsLimited(
          event.city, event.page, event.size);
      emit(UpcomingListSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidState());
        }
        emit(UpcomingListEntityException(e, e.title!));
      } else {
        emit(UpcomingListError("An unespected error occurred"));
      }
    }
  }

  void _fetchAccordingList(
      FetchAccordingListEvent event, Emitter<EventListState> emit) async {
    emit(EventListLoading());
    try {
      final response = await eventRepository.getAccordingEventsLimited(
          event.city, event.page, event.size);
      emit(AccordingListSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidState());
        }
        emit(AccordingListEntityException(e, e.title!));
      } else {
        emit(AccordingListError("An unespected error occurred"));
      }
    }
  }

  void _fetchEventTypeList(
      FetchEventTypeListEvent event, Emitter<EventListState> emit) async {
    emit(EventListLoading());
    try {
      final response = await eventRepository.getEventsByEventType(
          event.city, event.eventTypeId, event.page, event.size);
      emit(EventTypeListSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidState());
        }
        emit(EventTypeListEntityException(e, e.title!));
      } else {
        emit(EventTypeListError("An unespected error occurred"));
      }
    }
  }

  void _fetchUpcomingSearchableList(FetchUpcomingListSearchableEvent event,
      Emitter<EventListState> emit) async {
    emit(EventListLoading());
    try {
      final response = await eventRepository.getUpcomingEventsFiltered(
          event.city,
          event.name,
          event.eventTypes,
          event.startDate,
          event.endDate,
          event.minPrice,
          event.maxPrice);
      emit(UpcomingListSearchableSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidState());
        }
        emit(UpcomingListsearchableEntityException(e, e.title!));
      } else {
        emit(UpcomingListSearchableError("An unespected error occurred"));
      }
    }
  }
}

part of 'event_list_bloc.dart';

@immutable
sealed class EventListState {}

final class EventListInitial extends EventListState {}

final class EventListLoading extends EventListState {}

final class TokenNotValidState extends EventListState {}

final class UpcomingListSuccess extends EventListState {
  final ListEventsResponse listEventsResponse;
  UpcomingListSuccess(this.listEventsResponse);
}

final class UpcomingListError extends EventListState {
  final String errorMessage;
  UpcomingListError(this.errorMessage);
}

final class UpcomingListEntityException extends UpcomingListError {
  final GeneralException generalException;
  UpcomingListEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class AccordingListSuccess extends EventListState {
  final ListEventsResponse listEventsResponse;
  AccordingListSuccess(this.listEventsResponse);
}

final class AccordingListError extends EventListState {
  final String errorMessage;
  AccordingListError(this.errorMessage);
}

final class AccordingListEntityException extends UpcomingListError {
  final GeneralException generalException;
  AccordingListEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class EventTypeListSuccess extends EventListState {
  final ListEventsResponse listEventsResponse;
  EventTypeListSuccess(this.listEventsResponse);
}

final class EventTypeListError extends EventListState {
  final String errorMessage;
  EventTypeListError(this.errorMessage);
}

final class EventTypeListEntityException extends UpcomingListError {
  final GeneralException generalException;
  EventTypeListEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

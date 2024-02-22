part of 'event_list_bloc.dart';

@immutable
sealed class EventListState {}

final class EventListInitial extends EventListState {}

final class EventListLoading extends EventListState {}

final class EventListSuccess extends EventListState {
  final ListEventsResponse listEventsResponse;
  EventListSuccess(this.listEventsResponse);
}

final class EventListError extends EventListState {
  final String errorMessage;
  EventListError(this.errorMessage);
}

final class EventListEntityException extends EventListError {
  final GeneralException generalException;
  EventListEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

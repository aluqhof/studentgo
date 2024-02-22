part of 'event_type_bloc.dart';

@immutable
sealed class EventTypeState {}

final class EventTypeInitial extends EventTypeState {}

final class EventTypeLoading extends EventTypeState {}

final class EventTypeSuccess extends EventTypeState {
  final List<EventTypeResponse> eventTypeResponseList;
  EventTypeSuccess(this.eventTypeResponseList);
}

final class EventTypeError extends EventTypeState {
  final String errorMessage;
  EventTypeError(this.errorMessage);
}

part of 'all_events_calendar_bloc.dart';

@immutable
sealed class AllEventsCalendarState {}

final class AllEventsCalendarInitial extends AllEventsCalendarState {}

final class AllEventsCalendarLoading extends AllEventsCalendarState {}

final class AllEventsCalendarSuccess extends AllEventsCalendarState {
  final List<Content> events;
  AllEventsCalendarSuccess(this.events);
}

final class AllEventsCalendarError extends AllEventsCalendarState {
  final String errorMessage;
  AllEventsCalendarError(this.errorMessage);
}

final class TokenNotValidState extends AllEventsCalendarState {}

final class AllEventsEntityException extends AllEventsCalendarError {
  final GeneralException generalException;
  AllEventsEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

part of 'all_events_calendar_bloc.dart';

@immutable
sealed class AllEventsCalendarEvent {}

final class FetchAllEventsCalendar extends AllEventsCalendarEvent {
  final String cityName;
  FetchAllEventsCalendar(this.cityName);
}

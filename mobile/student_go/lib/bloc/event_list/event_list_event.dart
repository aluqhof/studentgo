part of 'event_list_bloc.dart';

@immutable
sealed class EventListEvent {}

final class FetchUpcomingListEvent extends EventListEvent {
  final String city;
  final int page;
  final int size;
  FetchUpcomingListEvent(this.city, this.page, this.size);
}

final class FetchAccordingListEvent extends EventListEvent {
  final String city;
  final int page;
  final int size;
  FetchAccordingListEvent(this.city, this.page, this.size);
}

final class FetchEventTypeListEvent extends EventListEvent {
  final String city;
  final int eventTypeId;
  final int page;
  final int size;
  FetchEventTypeListEvent(this.city, this.eventTypeId, this.page, this.size);
}

final class FetchUpcomingListSearchableEvent extends EventListEvent {
  final String city;
  final int page;
  final int size;
  final String name;
  FetchUpcomingListSearchableEvent(this.city, this.page, this.size, this.name);
}

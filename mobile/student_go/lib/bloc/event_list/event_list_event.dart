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
  final String name;
  final List<int> eventTypes;
  final DateTime startDate;
  final DateTime endDate;
  final double minPrice;
  final double maxPrice;
  FetchUpcomingListSearchableEvent(this.city, this.name, this.eventTypes,
      this.startDate, this.endDate, this.minPrice, this.maxPrice);
}

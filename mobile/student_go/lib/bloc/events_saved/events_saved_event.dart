part of 'events_saved_bloc.dart';

@immutable
sealed class EventsSavedEvent {}

final class FetchEventsSaved extends EventsSavedEvent {
  FetchEventsSaved();
}

class BookmarkEvent extends EventsSavedEvent {
  final String eventId;

  BookmarkEvent(this.eventId);
}

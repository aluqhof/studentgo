part of 'event_type_bloc.dart';

@immutable
sealed class EventTypeEvent {}

final class FetchEventTypeEvent extends EventTypeEvent {
  FetchEventTypeEvent();
}

part of 'event_details_bloc.dart';

@immutable
sealed class EventDetailsEvent {}

final class FetchEventDetails extends EventDetailsEvent {
  final String eventId;
  FetchEventDetails(this.eventId);
}

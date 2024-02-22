part of 'event_list_bloc.dart';

@immutable
sealed class EventListEvent {}

// ignore: must_be_immutable
final class FetchEventListEvent extends EventListEvent {
  String city;
  FetchEventListEvent(this.city);
}

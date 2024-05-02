part of 'event_image_bloc.dart';

@immutable
sealed class EventImageEvent {}

final class FetchEventImage extends EventImageEvent {
  final String id;
  final int index;
  FetchEventImage(this.id, this.index);
}

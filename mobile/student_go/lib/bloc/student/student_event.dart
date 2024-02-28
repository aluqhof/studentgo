part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

final class FetchStudent extends StudentEvent {
  FetchStudent();
}

final class SavedOrUnsavedEvent extends StudentEvent {
  final String eventId;
  SavedOrUnsavedEvent(this.eventId);
}

part of 'events_saved_bloc.dart';

@immutable
sealed class EventsSavedState {}

final class EventsSavedInitial extends EventsSavedState {}

final class EventsSavedLoading extends EventsSavedState {}

final class EventsSavedSuccess extends EventsSavedState {
  final List<Content> eventsSaved;
  EventsSavedSuccess(this.eventsSaved);
}

final class EventsSavedError extends EventsSavedState {
  final String errorMessage;
  EventsSavedError(this.errorMessage);
}

final class SaveUnsaveSuccess extends EventsSavedState {
  final StudentInfoResponse studentInfoResponse;
  SaveUnsaveSuccess(this.studentInfoResponse);
}

final class EventsSavedEntityException extends EventsSavedError {
  final GeneralException generalException;
  EventsSavedEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidState extends EventsSavedState {}

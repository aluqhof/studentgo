part of 'event_details_bloc.dart';

@immutable
sealed class EventDetailsState {}

final class EventDetailsInitial extends EventDetailsState {}

final class EventDetailsLoading extends EventDetailsState {}

final class EventDetailsSuccess extends EventDetailsState {
  final EventDetailsResponse eventDetails;
  EventDetailsSuccess(this.eventDetails);
}

final class EventDetailsError extends EventDetailsState {
  final String errorMessage;
  EventDetailsError(this.errorMessage);
}

final class TokenNotValidState extends EventDetailsState {}

final class EventDetailsEntityException extends EventDetailsError {
  final GeneralException generalException;
  EventDetailsEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

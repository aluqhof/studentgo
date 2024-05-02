part of 'event_image_bloc.dart';

@immutable
sealed class EventImageState {}

final class EventImageInitial extends EventImageState {}

final class EventImageLoading extends EventImageState {}

final class EventImageSuccess extends EventImageState {
  final Uint8List image;
  EventImageSuccess(this.image);
}

final class EventImageError extends EventImageState {
  final String errorMessage;
  EventImageError(this.errorMessage);
}

final class EventImageEntityException extends EventImageError {
  final GeneralException generalException;
  EventImageEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class EventImageValidationException extends EventImageError {
  final ValidationException validationException;
  EventImageValidationException(this.validationException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidStateEventImage extends EventImageState {}

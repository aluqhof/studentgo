part of 'profile_image_bloc.dart';

@immutable
sealed class ProfileImageState {}

final class ProfileImageInitial extends ProfileImageState {}

final class ProfileImageLoading extends ProfileImageState {}

final class ProfileImageSuccess extends ProfileImageState {
  final Uint8List image;
  ProfileImageSuccess(this.image);
}

final class ProfileImageError extends ProfileImageState {
  final String errorMessage;
  ProfileImageError(this.errorMessage);
}

final class ProfileImageEntityException extends ProfileImageError {
  final GeneralException generalException;
  ProfileImageEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class ProfileImageValidationException extends ProfileImageError {
  final ValidationException validationException;
  ProfileImageValidationException(this.validationException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidStateProfileImage extends ProfileImageState {}

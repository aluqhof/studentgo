part of 'upload_profile_photo_bloc.dart';

@immutable
sealed class UploadProfilePhotoState {}

final class UploadProfilePhotoInitial extends UploadProfilePhotoState {}

final class UploadProfilePhotoLoading extends UploadProfilePhotoState {}

final class UploadProfilePhotoSuccess extends UploadProfilePhotoState {
  final UploadResponse uploadResponse;
  UploadProfilePhotoSuccess(this.uploadResponse);
}

final class UploadProfilePhotoError extends UploadProfilePhotoState {
  final String errorMessage;
  UploadProfilePhotoError(this.errorMessage);
}

final class UploadProfilePhotoEntityException extends UploadProfilePhotoError {
  final GeneralException generalException;
  UploadProfilePhotoEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class UploadProfilePhotoValidationException
    extends UploadProfilePhotoError {
  final ValidationException validationException;
  UploadProfilePhotoValidationException(
      this.validationException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidStateUploadProfilePhoto
    extends UploadProfilePhotoState {}

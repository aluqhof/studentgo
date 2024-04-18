part of 'update_profile_bloc.dart';

@immutable
sealed class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoading extends UpdateProfileState {}

final class UpdateProfileSuccess extends UpdateProfileState {
  final StudentInfoResponse studentInfoResponse;
  UpdateProfileSuccess(this.studentInfoResponse);
}

final class UpdateProfileError extends UpdateProfileState {
  final String errorMessage;
  UpdateProfileError(this.errorMessage);
}

final class UpdateProfileEntityException extends UpdateProfileError {
  final GeneralException generalException;
  UpdateProfileEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class UpdateProfileValidationException extends UpdateProfileError {
  final ValidationException validationException;
  UpdateProfileValidationException(
      this.validationException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidStateUpdateProfile extends UpdateProfileState {}

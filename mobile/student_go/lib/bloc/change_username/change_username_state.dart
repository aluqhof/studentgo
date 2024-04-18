part of 'change_username_bloc.dart';

@immutable
sealed class ChangeUsernameState {}

final class ChangeUsernameInitial extends ChangeUsernameState {}

final class ChangeUsernameLoading extends ChangeUsernameState {}

final class ChangeUsernameSuccess extends ChangeUsernameState {
  final ChangeUserNameResponse changeUserNameResponse;
  ChangeUsernameSuccess(this.changeUserNameResponse);
}

final class ChangeUsernameError extends ChangeUsernameState {
  final String errorMessage;
  ChangeUsernameError(this.errorMessage);
}

final class ChangeUsernameEntityException extends ChangeUsernameError {
  final GeneralException generalException;
  ChangeUsernameEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class ChangeUsernameValidationException extends ChangeUsernameError {
  final ValidationException validationException;
  ChangeUsernameValidationException(
      this.validationException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidStateChangeUsername extends ChangeUsernameState {}

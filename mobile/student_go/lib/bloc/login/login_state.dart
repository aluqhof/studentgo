part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class DoLoginLoading extends LoginState {}

final class DoLoginSuccess extends LoginState {
  final LoginResponse userLogin;
  DoLoginSuccess(this.userLogin);
}

final class DoLoginError extends LoginState {
  final String errorMessage;
  DoLoginError(this.errorMessage);
}

final class DoLoginUserNotFoundException extends DoLoginError {
  final UserNotFoundException userNotFoundException;

  DoLoginUserNotFoundException(this.userNotFoundException, String message)
      : super(message);
}

final class DoLoginBadCredentialsException extends DoLoginError {
  final BadCredentialsException badCredentialsException;

  DoLoginBadCredentialsException(this.badCredentialsException, String message)
      : super(message);
}

part of 'register_student_bloc.dart';

@immutable
sealed class RegisterStudentState {}

final class RegisterStudentInitial extends RegisterStudentState {}

final class DoRegisterStudentLoading extends RegisterStudentState {}

final class DoRegisterStudentSuccess extends RegisterStudentState {
  final LoginResponse userRegister;
  DoRegisterStudentSuccess(this.userRegister);
}

final class DoRegisterStudentError extends RegisterStudentState {
  final String errorMessage;
  DoRegisterStudentError(this.errorMessage);
}

final class DoRegisterStudentBadRequestValidation
    extends DoRegisterStudentError {
  final BadRequestValidation badRequestValidation;
  DoRegisterStudentBadRequestValidation(
      this.badRequestValidation, String errorMessage)
      : super(errorMessage);
}

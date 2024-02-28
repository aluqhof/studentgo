part of 'student_bloc.dart';

@immutable
sealed class StudentState {}

final class StudentInitial extends StudentState {}

final class StudentLoading extends StudentState {}

final class StudentSuccess extends StudentState {
  final StudentInfoResponse studentInfoResponse;
  StudentSuccess(this.studentInfoResponse);
}

final class TokenNotValidState extends StudentState {}

final class StudentError extends StudentState {
  final String errorMessage;
  StudentError(this.errorMessage);
}

final class StudentGeneralException extends StudentError {
  final GeneralException generalException;
  StudentGeneralException(this.generalException, String errorMessage)
      : super(errorMessage);
}

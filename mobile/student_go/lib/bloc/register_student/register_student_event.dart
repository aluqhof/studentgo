part of 'register_student_bloc.dart';

@immutable
sealed class RegisterStudentEvent {}

class DoRegisterStudentEvent extends RegisterStudentEvent {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  DoRegisterStudentEvent(this.fullName, this.username, this.email,
      this.password, this.confirmPassword);
}

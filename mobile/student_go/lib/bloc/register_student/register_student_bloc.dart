import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/dto/register_dto.dart';
import 'package:student_go/models/response/bad_request_validation/bad_request_validation.dart';
import 'package:student_go/models/response/login_response.dart';
import 'package:student_go/repository/auth/auth_repository.dart';

part 'register_student_event.dart';
part 'register_student_state.dart';

class RegisterStudentBloc
    extends Bloc<RegisterStudentEvent, RegisterStudentState> {
  final AuthRepository authRepository;

  RegisterStudentBloc({required this.authRepository})
      : super(RegisterStudentInitial()) {
    on<DoRegisterStudentEvent>(_doRegisterStudent);
  }

  void _doRegisterStudent(
      DoRegisterStudentEvent event, Emitter<RegisterStudentState> emit) async {
    emit(DoRegisterStudentLoading());

    try {
      final RegisterDto registerDto = RegisterDto(
          username: event.username,
          password: event.password,
          verifyPassword: event.confirmPassword,
          email: event.email,
          name: event.fullName);
      final response = await authRepository.register(registerDto);
      emit(DoRegisterStudentSuccess(response));
      return;
    } catch (e) {
      if (e is BadRequestValidation) {
        emit(DoRegisterStudentBadRequestValidation(e, "Bad Request"));
      } else {
        emit(DoRegisterStudentError("An unexpected error occurred"));
      }
    }
  }
}

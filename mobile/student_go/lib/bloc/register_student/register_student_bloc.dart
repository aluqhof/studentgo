import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/dto/register_dto.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/login_response.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
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
          name: event.fullName,
          interests: event.interests);
      final response = await authRepository.register(registerDto);
      emit(DoRegisterStudentSuccess(response));
      return;
    } catch (e) {
      if (e is ValidationException) {
        emit(DoRegisterStudentBadRequestValidation(e, e.title!));
      } else if (e is GeneralException) {
        emit(DoRegisterStudentGeneralException(e, e.title!));
      } else {
        emit(DoRegisterStudentError("An unexpected error occurred"));
      }
    }
  }
}

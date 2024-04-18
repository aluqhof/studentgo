import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/dto/change_username_request.dart';
import 'package:student_go/models/response/change_user_name_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/student/student_repository.dart';

part 'change_username_event.dart';
part 'change_username_state.dart';

class ChangeUsernameBloc
    extends Bloc<ChangeUsernameEvent, ChangeUsernameState> {
  final StudentRepository studentRepository;
  ChangeUsernameBloc(this.studentRepository) : super(ChangeUsernameInitial()) {
    on<FetchUsernameChange>(_fetchUsernameChange);
  }

  void _fetchUsernameChange(
      FetchUsernameChange event, Emitter<ChangeUsernameState> emit) async {
    emit(ChangeUsernameLoading());
    try {
      ChangeUsernameRequest changeUsernameRequest =
          ChangeUsernameRequest(username: event.newUsername);
      final response =
          await studentRepository.changeUsername(changeUsernameRequest);
      emit(ChangeUsernameSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateChangeUsername());
        }
        emit(ChangeUsernameEntityException(e, e.title!));
      } else if (e is ValidationException) {
        emit(ChangeUsernameValidationException(e, e.title!));
      } else {
        emit(ChangeUsernameError("An unespected error occurred"));
      }
    }
  }
}

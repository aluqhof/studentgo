import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';
import 'package:student_go/repository/student/student_repository.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;
  StudentBloc(this.studentRepository) : super(StudentInitial()) {
    on<StudentEvent>(_fetchStudent);
    on<SavedOrUnsavedEvent>(_saveOrUnsaveEvent);
  }

  void _fetchStudent(StudentEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final response = await studentRepository.getStudentProfile();
      emit(StudentSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403 || e.status == 401) {
          emit(TokenNotValidState());
        }
        emit(StudentGeneralException(e, e.title!));
      } else {
        emit(StudentError("An unespected error occurred"));
      }
    }
  }

  void _saveOrUnsaveEvent(
      SavedOrUnsavedEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final response = await studentRepository.saveOrUnsaveEvent(event.eventId);
      emit(StudentSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403 || e.status == 401) {
          emit(TokenNotValidState());
        }
        emit(StudentGeneralException(e, e.title!));
      } else {
        emit(StudentError("An unespected error occurred"));
      }
    }
  }
}

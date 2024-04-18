import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/dto/update_profile_request.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/student/student_repository.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final StudentRepository studentRepository;
  UpdateProfileBloc(this.studentRepository) : super(UpdateProfileInitial()) {
    on<FetchProfileUpdate>(_fetchProfileUpdate);
  }

  void _fetchProfileUpdate(
      FetchProfileUpdate event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileLoading());
    try {
      UpdateProfileRequest updateProfileRequest = UpdateProfileRequest(
          name: event.name,
          description: event.description,
          interests: event.interests);
      final response =
          await studentRepository.updateProfile(updateProfileRequest);
      emit(UpdateProfileSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateUpdateProfile());
        }
        emit(UpdateProfileEntityException(e, e.title!));
      } else if (e is ValidationException) {
        emit(UpdateProfileValidationException(e, e.title!));
      } else {
        emit(UpdateProfileError("An unespected error occurred"));
      }
    }
  }
}

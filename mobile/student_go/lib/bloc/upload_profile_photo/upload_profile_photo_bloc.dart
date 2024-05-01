import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/upload_response.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/student/student_repository.dart';

part 'upload_profile_photo_event.dart';
part 'upload_profile_photo_state.dart';

class UploadProfilePhotoBloc
    extends Bloc<UploadProfilePhotoEvent, UploadProfilePhotoState> {
  final StudentRepository studentRepository;
  UploadProfilePhotoBloc(this.studentRepository)
      : super(UploadProfilePhotoInitial()) {
    on<FetchProfilePhotoUpload>(_fetchPhotoUpload);
  }

  void _fetchPhotoUpload(FetchProfilePhotoUpload event,
      Emitter<UploadProfilePhotoState> emit) async {
    emit(UploadProfilePhotoLoading());
    try {
      final response = await studentRepository.uploadProfilePhoto(event.image);
      emit(UploadProfilePhotoSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateUploadProfilePhoto());
        }
        emit(UploadProfilePhotoEntityException(e, e.title!));
      } else if (e is ValidationException) {
        emit(UploadProfilePhotoValidationException(e, e.title!));
      } else {
        emit(UploadProfilePhotoError("An unespected error occurred"));
      }
    }
  }
}

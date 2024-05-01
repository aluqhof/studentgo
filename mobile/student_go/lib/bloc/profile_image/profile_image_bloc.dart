import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/student/student_repository.dart';

part 'profile_image_event.dart';
part 'profile_image_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  final StudentRepository studentRepository;
  ProfileImageBloc(this.studentRepository) : super(ProfileImageInitial()) {
    on<FetchProfileImage>(_fetchProfileImage);
    on<FetchProfileImageById>(_fetchProfileImageId);
  }

  void _fetchProfileImage(
      FetchProfileImage event, Emitter<ProfileImageState> emit) async {
    emit(ProfileImageLoading());
    try {
      final response = await studentRepository.getUserPhoto();
      emit(ProfileImageSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateProfileImage());
        }
        emit(ProfileImageEntityException(e, e.title!));
      } else if (e is ValidationException) {
        emit(ProfileImageValidationException(e, e.title!));
      } else {
        emit(ProfileImageError("An unespected error occurred"));
      }
    }
  }

  void _fetchProfileImageId(
      FetchProfileImageById event, Emitter<ProfileImageState> emit) async {
    emit(ProfileImageLoading());
    try {
      final response = await studentRepository.getUserPhotoById(event.id);
      emit(ProfileImageSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateProfileImage());
        }
        emit(ProfileImageEntityException(e, e.title!));
      } else if (e is ValidationException) {
        emit(ProfileImageValidationException(e, e.title!));
      } else {
        emit(ProfileImageError("An unespected error occurred"));
      }
    }
  }
}

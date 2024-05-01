import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:student_go/models/dto/change_username_request.dart';
import 'package:student_go/models/dto/update_profile_request.dart';
import 'package:student_go/models/response/change_user_name_response.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';
import 'package:student_go/models/response/upload_response.dart';

abstract class StudentRepository {
  Future<StudentInfoResponse> getStudentProfile();
  Future<StudentInfoResponse> saveOrUnsaveEvent(String eventId);
  Future<List<Content>> getAllSavedEvents();
  Future<ChangeUserNameResponse> changeUsername(
      ChangeUsernameRequest changeUsernameRequest);
  Future<StudentInfoResponse> updateProfile(
      UpdateProfileRequest updateProfileRequest);
  Future<Uint8List> getUserPhoto();
  Future<UploadResponse> uploadProfilePhoto(XFile image);
}

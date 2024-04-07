import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';

abstract class StudentRepository {
  Future<StudentInfoResponse> getStudentProfile();
  Future<StudentInfoResponse> saveOrUnsaveEvent(String eventId);
  Future<List<Content>> getAllSavedEvents();
}

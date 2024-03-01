import 'package:student_go/models/response/event_saved_response.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';

abstract class StudentRepository {
  Future<StudentInfoResponse> getStudentProfile();
  Future<StudentInfoResponse> saveOrUnsaveEvent(String eventId);
  Future<List<EventSavedResponse>> getAllSavedEvents();
}

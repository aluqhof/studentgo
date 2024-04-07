import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:student_go/interceptor/auth_request_interceptor.dart';
import 'package:student_go/models/response/event_saved_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';
import 'package:student_go/repository/student/student_repository.dart';

class StudentRepositoryImp extends StudentRepository {
  final Client _httpClient = InterceptedClient.build(interceptors: [
    AuthRequestInterceptor(),
  ]);

  @override
  Future<StudentInfoResponse> getStudentProfile() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/student/'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return StudentInfoResponse.fromJson(response.body);
      } else {
        throw Exception('Failed to get event types');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }

  @override
  Future<StudentInfoResponse> saveOrUnsaveEvent(String eventId) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('http://10.0.2.2:8080/student/save-unsave-event/$eventId'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return StudentInfoResponse.fromJson(response.body);
      } else {
        throw Exception('Failed to save or unsave event');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }

  @override
  Future<List<Content>> getAllSavedEvents() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/student/saved-events'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Content> eventsSaved =
            jsonData.map((x) => Content.fromMap(x)).toList();
        return eventsSaved;
      } else {
        throw Exception('Failed to save or unsave event');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }
}

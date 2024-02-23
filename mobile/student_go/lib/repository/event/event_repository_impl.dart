import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/interceptor/auth_request_interceptor.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final Client _httpClient = InterceptedClient.build(interceptors: [
    AuthRequestInterceptor(),
  ]);

  @override
  Future<ListEventsResponse> getUpcomingEventsLimited(String city) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('http://10.0.2.2:8080/event/upcoming-limit/$city'),
        //Uri.parse('http://localhost:8080/auth/login'),
      );

      if (response.statusCode == 200) {
        return ListEventsResponse.fromJson(response.body);
      } else if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        return Future.error(GeneralException.fromJson(response.body));
      } else {
        throw Exception('Failed to get events');
      }
    } catch (e) {
      if (e is GeneralException) {
        rethrow;
      }
      throw Exception('Something wrong');
    }
  }
}

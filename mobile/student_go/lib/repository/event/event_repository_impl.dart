import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final Client _httpClient = Client();

  @override
  Future<ListEventsResponse> getUpcomingEventsLimited(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await _httpClient.get(
      Uri.parse('http://10.0.2.2:8080/event/upcoming-limit/$city'),
      //Uri.parse('http://localhost:8080/auth/login'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8'
      },
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
  }
}

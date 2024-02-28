import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';

class EventTypeRepositoryImpl extends EventTypeRepository {
  final Client _httpClient = Client();

  @override
  Future<List<EventTypeResponse>> getAllEventTypes() async {
    final response = await _httpClient.get(
      Uri.parse('http://10.0.2.2:8080/event-type/'),
      //Uri.parse('http://localhost:8080/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      //final List<dynamic> jsonList = jsonDecode(response.body);
      final List<dynamic> jsonData = json.decode(response.body);
      final List<EventTypeResponse> eventTypes =
          jsonData.map((x) => EventTypeResponse.fromMap(x)).toList();
      return eventTypes;
    } else {
      throw Exception('Failed to get event types');
    }
  }
}

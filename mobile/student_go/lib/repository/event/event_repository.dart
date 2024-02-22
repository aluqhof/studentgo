import 'package:student_go/models/response/list_events_response/list_events_response.dart';

abstract class EventRepository {
  Future<ListEventsResponse> getUpcomingEventsLimited(String city);
}

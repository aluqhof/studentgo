import 'package:student_go/models/response/event_details_response/event_details_response.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';

abstract class EventRepository {
  Future<ListEventsResponse> getUpcomingEventsLimited(
      String city, int page, int size);
  Future<ListEventsResponse> getAccordingEventsLimited(
      String city, int page, int size);
  Future<ListEventsResponse> getEventsByEventType(
    String city,
    int eventTypeId,
    int page,
    int size,
  );

  Future<EventDetailsResponse> getEventDetails(String eventId);
  Future<List<Content>> getAllEvents(String cityName);
  Future<List<Content>> getUpcomingEventsFiltered(
      String city,
      String name,
      List<int>? eventTypes,
      DateTime? startDate,
      DateTime? endDate,
      double minPrice,
      double maxPrice);
}

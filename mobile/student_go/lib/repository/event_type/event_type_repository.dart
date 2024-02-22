import 'package:student_go/models/response/event_type_response.dart';

abstract class EventTypeRepository {
  Future<List<EventTypeResponse>> getAllEventTypes();
}

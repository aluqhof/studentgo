import 'dart:convert';

class EventSavedResponse {
  String? eventId;

  EventSavedResponse({this.eventId});

  factory EventSavedResponse.fromMap(Map<String, dynamic> data) {
    return EventSavedResponse(
      eventId: data['eventId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'eventId': eventId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventSavedResponse].
  factory EventSavedResponse.fromJson(String data) {
    return EventSavedResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventSavedResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

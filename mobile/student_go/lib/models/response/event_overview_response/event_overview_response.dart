import 'dart:convert';

import 'event_type.dart';

class EventOverviewResponse {
  String? uuid;
  String? name;
  double? latitude;
  double? longitude;
  String? cityId;
  String? dateTime;
  List<EventType>? eventType;

  EventOverviewResponse({
    this.uuid,
    this.name,
    this.latitude,
    this.longitude,
    this.cityId,
    this.dateTime,
    this.eventType,
  });

  factory EventOverviewResponse.fromMap(Map<String, dynamic> data) {
    return EventOverviewResponse(
      uuid: data['uuid'] as String?,
      name: data['name'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      cityId: data['cityId'] as String?,
      dateTime: data['dateTime'] as String?,
      eventType: (data['eventType'] as List<dynamic>?)
          ?.map((e) => EventType.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'dateTime': dateTime,
        'eventType': eventType?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventOverviewResponse].
  factory EventOverviewResponse.fromJson(String data) {
    return EventOverviewResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventOverviewResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

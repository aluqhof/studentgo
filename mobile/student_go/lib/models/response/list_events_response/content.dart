import 'dart:convert';

import 'package:student_go/models/response/event_type_response.dart';

import 'student.dart';

class Content {
  String? uuid;
  String? name;
  double? latitude;
  double? longitude;
  String? cityId;
  String? dateTime;
  List<EventTypeResponse>? eventType;
  List<Student>? students;

  Content(
      {this.uuid,
      this.name,
      this.latitude,
      this.longitude,
      this.cityId,
      this.dateTime,
      this.eventType,
      this.students});

  factory Content.fromMap(Map<String, dynamic> data) => Content(
        uuid: data['uuid'] as String?,
        name: data['name'] as String?,
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        cityId: data['cityId'] as String?,
        dateTime: data['dateTime'] as String?,
        eventType: (data['eventType'] as List<dynamic>?)
            ?.map((e) => EventTypeResponse.fromMap(e as Map<String, dynamic>))
            .toList(),
        students: (data['students'] as List<dynamic>?)
            ?.map((e) => Student.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'dateTime': dateTime,
        'eventType': eventType,
        'students': students?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Content].
  factory Content.fromJson(String data) {
    return Content.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Content] to a JSON string.
  String toJson() => json.encode(toMap());
}

import 'dart:convert';

import 'package:student_go/models/response/event_details_response/organizer.dart';

import 'student.dart';

class EventDetailsResponse {
  String? uuid;
  String? name;
  double? latitude;
  double? longitude;
  String? description;
  String? cityId;
  double? price;
  String? place;
  String? dateTime;
  Organizer? organizer;
  List<dynamic>? eventType;
  List<Student>? students;
  List<dynamic>? urlPhotos;
  int? maxCapacity;

  EventDetailsResponse(
      {this.uuid,
      this.name,
      this.latitude,
      this.longitude,
      this.description,
      this.cityId,
      this.price,
      this.place,
      this.dateTime,
      this.organizer,
      this.eventType,
      this.students,
      this.urlPhotos,
      this.maxCapacity});

  factory EventDetailsResponse.fromMap(Map<String, dynamic> data) =>
      EventDetailsResponse(
          uuid: data['uuid'] as String?,
          name: data['name'] as String?,
          latitude: (data['latitude'] as num?)?.toDouble(),
          longitude: (data['longitude'] as num?)?.toDouble(),
          description: data['description'] as String?,
          cityId: data['cityId'] as String?,
          price: (data['price'] as num?)?.toDouble(),
          place: data['place'] as String?,
          dateTime: data['dateTime'] as String?,
          organizer: data['organizer'] == null
              ? null
              : Organizer.fromMap(data['organizer'] as Map<String, dynamic>),
          eventType: data['eventType'] as List<dynamic>?,
          students: (data['students'] as List<dynamic>?)
              ?.map((e) => Student.fromMap(e as Map<String, dynamic>))
              .toList(),
          urlPhotos: data['urlPhotos'] as List<dynamic>?,
          maxCapacity: data['maxCapacity'] as int?);

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'cityId': cityId,
        'price': price,
        'place': place,
        'dateTime': dateTime,
        'organizer': organizer?.toMap(),
        'eventType': eventType,
        'students': students?.map((e) => e.toMap()).toList(),
        'urlPhotos': urlPhotos
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventDetailsResponse].
  factory EventDetailsResponse.fromJson(String data) {
    return EventDetailsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventDetailsResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

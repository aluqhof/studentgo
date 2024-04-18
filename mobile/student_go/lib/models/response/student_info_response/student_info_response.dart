import 'dart:convert';

import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/models/response/student_info_response/event.dart';

class StudentInfoResponse {
  String? id;
  String? username;
  String? name;
  String? description;
  List<EventTypeResponse>? interests;
  List<Event>? events;

  StudentInfoResponse(
      {this.id,
      this.username,
      this.name,
      this.description,
      this.interests,
      this.events});

  factory StudentInfoResponse.fromMap(Map<String, dynamic> data) {
    return StudentInfoResponse(
        id: data['id'] as String?,
        username: data['username'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        interests: (data['interests'] as List<dynamic>?)
            ?.map((e) => EventTypeResponse.fromMap(e as Map<String, dynamic>))
            .toList(),
        events: (data['events'] as List<dynamic>?)
            ?.map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList());
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'name': name,
        'description': description,
        'interests': interests?.map((e) => e.toMap()).toList(),
        'events': events?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StudentInfoResponse].
  factory StudentInfoResponse.fromJson(String data) {
    return StudentInfoResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [StudentInfoResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

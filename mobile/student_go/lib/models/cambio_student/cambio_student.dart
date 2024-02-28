import 'dart:convert';

import 'event.dart';
import 'interest.dart';

class CambioStudent {
  String? id;
  String? username;
  String? name;
  String? description;
  List<Interest>? interests;
  List<Event>? events;

  CambioStudent({
    this.id,
    this.username,
    this.name,
    this.description,
    this.interests,
    this.events,
  });

  factory CambioStudent.fromMap(Map<String, dynamic> data) => CambioStudent(
        id: data['id'] as String?,
        username: data['username'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        interests: (data['interests'] as List<dynamic>?)
            ?.map((e) => Interest.fromMap(e as Map<String, dynamic>))
            .toList(),
        events: (data['events'] as List<dynamic>?)
            ?.map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

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
  /// Parses the string and returns the resulting Json object as [CambioStudent].
  factory CambioStudent.fromJson(String data) {
    return CambioStudent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CambioStudent] to a JSON string.
  String toJson() => json.encode(toMap());
}

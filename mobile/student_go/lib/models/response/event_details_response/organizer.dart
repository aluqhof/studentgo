import 'dart:convert';

class Organizer {
  String? id;
  String? name;
  String? username;

  Organizer({this.id, this.name, this.username});

  factory Organizer.fromMap(Map<String, dynamic> data) => Organizer(
        id: data['id'] as String?,
        name: data['name'] as String?,
        username: data['username'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'username': username,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Organizer].
  factory Organizer.fromJson(String data) {
    return Organizer.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Organizer] to a JSON string.
  String toJson() => json.encode(toMap());
}

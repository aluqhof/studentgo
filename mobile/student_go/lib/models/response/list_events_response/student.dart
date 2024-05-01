import 'dart:convert';

class Student {
  String? id;
  String? username;
  String? name;
  String? userPhoto;

  Student({this.id, this.username, this.name, this.userPhoto});

  factory Student.fromMap(Map<String, dynamic> data) => Student(
        id: data['id'] as String?,
        username: data['username'] as String?,
        name: data['name'] as String?,
        userPhoto: data['userPhoto'] as String?,
      );

  Map<String, dynamic> toMap() =>
      {'id': id, 'username': username, 'name': name, 'userPhoto': userPhoto};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Student].
  factory Student.fromJson(String data) {
    return Student.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Student] to a JSON string.
  String toJson() => json.encode(toMap());
}

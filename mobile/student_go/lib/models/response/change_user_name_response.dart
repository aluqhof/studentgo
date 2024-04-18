import 'dart:convert';

class ChangeUserNameResponse {
  String? id;
  String? username;

  ChangeUserNameResponse({this.id, this.username});

  factory ChangeUserNameResponse.fromMap(Map<String, dynamic> data) {
    return ChangeUserNameResponse(
      id: data['id'] as String?,
      username: data['username'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChangeUserNameResponse].
  factory ChangeUserNameResponse.fromJson(String data) {
    return ChangeUserNameResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChangeUserNameResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

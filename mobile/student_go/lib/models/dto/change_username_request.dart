import 'dart:convert';

class ChangeUsernameRequest {
  String? username;

  ChangeUsernameRequest({this.username});

  factory ChangeUsernameRequest.fromMap(Map<String, dynamic> data) {
    return ChangeUsernameRequest(
      username: data['username'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'username': username,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChangeUsernameRequest].
  factory ChangeUsernameRequest.fromJson(String data) {
    return ChangeUsernameRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChangeUsernameRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}

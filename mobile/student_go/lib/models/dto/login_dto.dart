import 'dart:convert';

class LoginDto {
  String? username;
  String? password;

  LoginDto({this.username, this.password});

  factory LoginDto.fromMap(Map<String, dynamic> data) => LoginDto(
        username: data['username'] as String?,
        password: data['password'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginDto].
  factory LoginDto.fromJson(String data) {
    return LoginDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginDto] to a JSON string.
  String toJson() => json.encode(toMap());
}

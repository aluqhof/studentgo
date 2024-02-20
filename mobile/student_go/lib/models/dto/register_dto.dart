import 'dart:convert';

class RegisterDto {
  String? username;
  String? password;
  String? verifyPassword;
  String? email;
  String? name;

  RegisterDto({
    this.username,
    this.password,
    this.verifyPassword,
    this.email,
    this.name,
  });

  factory RegisterDto.fromMap(Map<String, dynamic> data) => RegisterDto(
        username: data['username'] as String?,
        password: data['password'] as String?,
        verifyPassword: data['verifyPassword'] as String?,
        email: data['email'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'verifyPassword': verifyPassword,
        'email': email,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterDto].
  factory RegisterDto.fromJson(String data) {
    return RegisterDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegisterDto] to a JSON string.
  String toJson() => json.encode(toMap());
}

import 'dart:convert';

class LoginResponse {
  String? id;
  String? username;
  String? name;
  String? role;
  String? createdAt;
  String? token;

  LoginResponse({
    this.id,
    this.username,
    this.name,
    this.role,
    this.createdAt,
    this.token,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> data) => LoginResponse(
        id: data['id'] as String?,
        username: data['username'] as String?,
        name: data['name'] as String?,
        role: data['role'] as String?,
        createdAt: data['createdAt'] as String?,
        token: data['token'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'name': name,
        'role': role,
        'createdAt': createdAt,
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginResponse].
  factory LoginResponse.fromJson(String data) {
    return LoginResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

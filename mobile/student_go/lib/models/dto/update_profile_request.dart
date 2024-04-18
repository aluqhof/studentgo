import 'dart:convert';

class UpdateProfileRequest {
  String? name;
  String? description;
  List<int>? interests;

  UpdateProfileRequest({this.name, this.description, this.interests});

  factory UpdateProfileRequest.fromMap(Map<String, dynamic> data) {
    return UpdateProfileRequest(
      name: data['name'] as String?,
      description: data['description'] as String?,
      interests: data['interests'] as List<int>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'interests': interests,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UpdateProfileRequest].
  factory UpdateProfileRequest.fromJson(String data) {
    return UpdateProfileRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UpdateProfileRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}

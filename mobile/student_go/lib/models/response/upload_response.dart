import 'dart:convert';

class UploadResponse {
  String? name;
  String? uri;
  String? type;
  int? size;

  UploadResponse({this.name, this.uri, this.type, this.size});

  factory UploadResponse.fromMap(Map<String, dynamic> data) {
    return UploadResponse(
      name: data['name'] as String?,
      uri: data['uri'] as String?,
      type: data['type'] as String?,
      size: data['size'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'uri': uri,
        'type': type,
        'size': size,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UploadResponse].
  factory UploadResponse.fromJson(String data) {
    return UploadResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UploadResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

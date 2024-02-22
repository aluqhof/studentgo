import 'dart:convert';

class EventTypeResponse {
  int? id;
  String? name;
  String? iconRef;
  String? colorCode;

  EventTypeResponse({this.id, this.name, this.iconRef, this.colorCode});

  factory EventTypeResponse.fromMap(Map<String, dynamic> data) {
    return EventTypeResponse(
      id: data['id'] as int?,
      name: data['name'] as String?,
      iconRef: data['iconRef'] as String?,
      colorCode: data['colorCode'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'iconRef': iconRef,
        'colorCode': colorCode,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventTypeResponse].
  factory EventTypeResponse.fromJson(String data) {
    return EventTypeResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventTypeResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

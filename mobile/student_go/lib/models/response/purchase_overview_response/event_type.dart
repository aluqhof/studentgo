import 'dart:convert';

class EventType {
  int? id;
  String? name;
  String? iconRef;
  String? colorCode;

  EventType({this.id, this.name, this.iconRef, this.colorCode});

  factory EventType.fromMap(Map<String, dynamic> data) => EventType(
        id: data['id'] as int?,
        name: data['name'] as String?,
        iconRef: data['iconRef'] as String?,
        colorCode: data['colorCode'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'iconRef': iconRef,
        'colorCode': colorCode,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventType].
  factory EventType.fromJson(String data) {
    return EventType.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventType] to a JSON string.
  String toJson() => json.encode(toMap());
}

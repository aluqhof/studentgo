import 'dart:convert';

class Interest {
  int? id;
  String? name;
  String? iconRef;
  String? colorCode;

  Interest({this.id, this.name, this.iconRef, this.colorCode});

  factory Interest.fromMap(Map<String, dynamic> data) => Interest(
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
  /// Parses the string and returns the resulting Json object as [Interest].
  factory Interest.fromJson(String data) {
    return Interest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Interest] to a JSON string.
  String toJson() => json.encode(toMap());
}

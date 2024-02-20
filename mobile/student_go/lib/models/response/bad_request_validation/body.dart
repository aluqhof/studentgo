import 'dart:convert';

import 'fields_error.dart';

class Body {
  String? type;
  String? title;
  int? status;
  String? detail;
  List<FieldsError>? fieldsErrors;

  Body({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.fieldsErrors,
  });

  factory Body.fromMap(Map<String, dynamic> data) => Body(
        type: data['type'] as String?,
        title: data['title'] as String?,
        status: data['status'] as int?,
        detail: data['detail'] as String?,
        fieldsErrors: (data['Fields errors'] as List<dynamic>?)
            ?.map((e) => FieldsError.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'status': status,
        'detail': detail,
        'Fields errors': fieldsErrors?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Body].
  factory Body.fromJson(String data) {
    return Body.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Body] to a JSON string.
  String toJson() => json.encode(toMap());
}

import 'dart:convert';

import 'fields_error.dart';

class ValidationException {
  String? type;
  String? title;
  int? status;
  String? detail;
  String? instance;
  List<FieldsError>? fieldsErrors;

  ValidationException({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
    this.fieldsErrors,
  });

  factory ValidationException.fromMap(Map<String, dynamic> data) {
    return ValidationException(
      type: data['type'] as String?,
      title: data['title'] as String?,
      status: data['status'] as int?,
      detail: data['detail'] as String?,
      instance: data['instance'] as String?,
      fieldsErrors: (data['Fields errors'] as List<dynamic>?)
          ?.map((e) => FieldsError.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'status': status,
        'detail': detail,
        'instance': instance,
        'Fields errors': fieldsErrors?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ValidationException].
  factory ValidationException.fromJson(String data) {
    return ValidationException.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ValidationException] to a JSON string.
  String toJson() => json.encode(toMap());
}

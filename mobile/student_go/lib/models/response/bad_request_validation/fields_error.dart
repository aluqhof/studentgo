import 'dart:convert';

class FieldsError {
  String? object;
  String? message;
  String? field;
  String? rejectedValue;

  FieldsError({this.object, this.message, this.field, this.rejectedValue});

  factory FieldsError.fromMap(Map<String, dynamic> data) => FieldsError(
        object: data['object'] as String?,
        message: data['message'] as String?,
        field: data['field'] as String?,
        rejectedValue: data['rejectedValue'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'object': object,
        'message': message,
        'field': field,
        'rejectedValue': rejectedValue,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [FieldsError].
  factory FieldsError.fromJson(String data) {
    return FieldsError.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [FieldsError] to a JSON string.
  String toJson() => json.encode(toMap());
}

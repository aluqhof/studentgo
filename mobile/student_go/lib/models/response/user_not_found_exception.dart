import 'dart:convert';

class UserNotFoundException {
  String? type;
  String? title;
  int? status;
  String? detail;
  String? instance;
  DateTime? timestamp;

  UserNotFoundException({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
    this.timestamp,
  });

  factory UserNotFoundException.fromMap(Map<String, dynamic> data) {
    return UserNotFoundException(
      type: data['type'] as String?,
      title: data['title'] as String?,
      status: data['status'] as int?,
      detail: data['detail'] as String?,
      instance: data['instance'] as String?,
      timestamp: data['timestamp'] == null
          ? null
          : DateTime.parse(data['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'status': status,
        'detail': detail,
        'instance': instance,
        'timestamp': timestamp?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserNotFoundException].
  factory UserNotFoundException.fromJson(String data) {
    return UserNotFoundException.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserNotFoundException] to a JSON string.
  String toJson() => json.encode(toMap());
}

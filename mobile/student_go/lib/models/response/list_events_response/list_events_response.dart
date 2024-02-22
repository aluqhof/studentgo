import 'dart:convert';

import 'result.dart';

class ListEventsResponse {
  String? name;
  List<Result>? result;

  ListEventsResponse({this.name, this.result});

  factory ListEventsResponse.fromMap(Map<String, dynamic> data) {
    return ListEventsResponse(
      name: data['name'] as String?,
      result: (data['result'] as List<dynamic>?)
          ?.map((e) => Result.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'result': result?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ListEventsResponse].
  factory ListEventsResponse.fromJson(String data) {
    return ListEventsResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ListEventsResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

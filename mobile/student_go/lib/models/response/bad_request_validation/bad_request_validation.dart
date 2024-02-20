import 'dart:convert';

import 'body.dart';
import 'headers.dart';

class BadRequestValidation {
  String? statusCode;
  Headers? headers;
  String? typeMessageCode;
  String? titleMessageCode;
  String? detailMessageCode;
  dynamic detailMessageArguments;
  Body? body;

  BadRequestValidation({
    this.statusCode,
    this.headers,
    this.typeMessageCode,
    this.titleMessageCode,
    this.detailMessageCode,
    this.detailMessageArguments,
    this.body,
  });

  factory BadRequestValidation.fromMap(Map<String, dynamic> data) {
    return BadRequestValidation(
      statusCode: data['statusCode'] as String?,
      headers: data['headers'] == null
          ? null
          : Headers.fromMap(data['headers'] as Map<String, dynamic>),
      typeMessageCode: data['typeMessageCode'] as String?,
      titleMessageCode: data['titleMessageCode'] as String?,
      detailMessageCode: data['detailMessageCode'] as String?,
      detailMessageArguments: data['detailMessageArguments'] as dynamic,
      body: data['body'] == null
          ? null
          : Body.fromMap(data['body'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'statusCode': statusCode,
        'headers': headers?.toMap(),
        'typeMessageCode': typeMessageCode,
        'titleMessageCode': titleMessageCode,
        'detailMessageCode': detailMessageCode,
        'detailMessageArguments': detailMessageArguments,
        'body': body?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BadRequestValidation].
  factory BadRequestValidation.fromJson(String data) {
    return BadRequestValidation.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BadRequestValidation] to a JSON string.
  String toJson() => json.encode(toMap());
}

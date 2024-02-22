import 'dart:convert';

class Result {
  String? uuid;
  String? name;
  double? latitude;
  double? longitude;
  String? cityId;
  String? description;
  String? dateTime;
  String? organizer;
  List<dynamic>? eventTypes;

  Result({
    this.uuid,
    this.name,
    this.latitude,
    this.longitude,
    this.cityId,
    this.description,
    this.dateTime,
    this.organizer,
    this.eventTypes,
  });

  factory Result.fromMap(Map<String, dynamic> data) => Result(
        uuid: data['uuid'] as String?,
        name: data['name'] as String?,
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        cityId: data['cityId'] as String?,
        description: data['description'] as String?,
        dateTime: data['dateTime'] as String?,
        organizer: data['organizer'] as String?,
        eventTypes: data['eventTypes'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'description': description,
        'dateTime': dateTime,
        'organizer': organizer,
        'eventTypes': eventTypes,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Result].
  factory Result.fromJson(String data) {
    return Result.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Result] to a JSON string.
  String toJson() => json.encode(toMap());
}

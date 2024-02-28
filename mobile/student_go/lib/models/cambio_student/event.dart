import 'dart:convert';

class Event {
  String? uuid;
  String? name;
  double? latitude;
  double? longitude;
  String? cityId;
  String? dateTime;

  Event({
    this.uuid,
    this.name,
    this.latitude,
    this.longitude,
    this.cityId,
    this.dateTime,
  });

  factory Event.fromMap(Map<String, dynamic> data) => Event(
        uuid: data['uuid'] as String?,
        name: data['name'] as String?,
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        cityId: data['cityId'] as String?,
        dateTime: data['dateTime'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'dateTime': dateTime,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Event].
  factory Event.fromJson(String data) {
    return Event.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Event] to a JSON string.
  String toJson() => json.encode(toMap());
}

import 'dart:convert';

import 'event_type.dart';

class PurchaseOverviewResponse {
  String? purchaseId;
  String? eventId;
  String? name;
  double? latitude;
  double? longitude;
  String? cityId;
  String? dateTime;
  List<EventType>? eventType;
  List<dynamic>? urlPhotos;

  PurchaseOverviewResponse(
      {this.purchaseId,
      this.eventId,
      this.name,
      this.latitude,
      this.longitude,
      this.cityId,
      this.dateTime,
      this.eventType,
      this.urlPhotos});

  factory PurchaseOverviewResponse.fromMap(Map<String, dynamic> data) {
    return PurchaseOverviewResponse(
        purchaseId: data['purchaseId'] as String?,
        eventId: data['eventId'] as String?,
        name: data['name'] as String?,
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        cityId: data['cityId'] as String?,
        dateTime: data['dateTime'] as String?,
        eventType: (data['eventType'] as List<dynamic>?)
            ?.map((e) => EventType.fromMap(e as Map<String, dynamic>))
            .toList(),
        urlPhotos: data['urlPhotos'] as List<dynamic>?);
  }

  Map<String, dynamic> toMap() => {
        'purchaseId': purchaseId,
        'eventId': eventId,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'dateTime': dateTime,
        'eventType': eventType?.map((e) => e.toMap()).toList(),
        'urlPhotos': urlPhotos
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PurchaseOverviewResponse].
  factory PurchaseOverviewResponse.fromJson(String data) {
    return PurchaseOverviewResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PurchaseOverviewResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

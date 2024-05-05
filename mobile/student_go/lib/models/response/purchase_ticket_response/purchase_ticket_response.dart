import 'dart:convert';

import 'event_type.dart';

class PurchaseTicketResponse {
  String? id;
  String? eventName;
  double? latitude;
  double? longitude;
  String? eventDate;
  List<EventType>? eventType;
  double? price;
  String? participant;
  String? qrCode;

  PurchaseTicketResponse(
      {this.id,
      this.eventName,
      this.latitude,
      this.longitude,
      this.eventDate,
      this.eventType,
      this.price,
      this.participant,
      this.qrCode});

  factory PurchaseTicketResponse.fromMap(Map<String, dynamic> data) {
    return PurchaseTicketResponse(
        id: data['id'] as String?,
        eventName: data['eventName'] as String?,
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        eventDate: data['eventDate'] as String?,
        eventType: (data['eventType'] as List<dynamic>?)
            ?.map((e) => EventType.fromMap(e as Map<String, dynamic>))
            .toList(),
        price: data['price'] as double?,
        participant: data['participant'] as String?,
        qrCode: data['qrCode'] as String?);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'eventName': eventName,
        'latitude': latitude,
        'longitude': longitude,
        'eventDate': eventDate,
        'eventType': eventType?.map((e) => e.toMap()).toList(),
        'price': price,
        'participant': participant,
        'qrCode': qrCode
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PurchaseTicketResponse].
  factory PurchaseTicketResponse.fromJson(String data) {
    return PurchaseTicketResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PurchaseTicketResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

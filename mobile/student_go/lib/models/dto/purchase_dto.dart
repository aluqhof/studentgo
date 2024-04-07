import 'dart:convert';

class PurchaseDto {
  String? eventId;
  int? numberOfTickets;

  PurchaseDto({this.eventId, this.numberOfTickets});

  factory PurchaseDto.fromMap(Map<String, dynamic> data) => PurchaseDto(
        eventId: data['eventId'] as String?,
        numberOfTickets: data['numberOfTickets'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'eventId': eventId,
        'numberOfTickets': numberOfTickets,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PurchaseDto].
  factory PurchaseDto.fromJson(String data) {
    return PurchaseDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PurchaseDto] to a JSON string.
  String toJson() => json.encode(toMap());
}

import 'dart:convert';

class PurchaseResponse {
  String? id;
  DateTime? dateTime;
  int? numberOfTickets;
  double? totalPrice;
  String? eventId;
  String? author;

  PurchaseResponse({
    this.id,
    this.dateTime,
    this.numberOfTickets,
    this.totalPrice,
    this.eventId,
    this.author,
  });

  factory PurchaseResponse.fromMap(Map<String, dynamic> data) {
    return PurchaseResponse(
      id: data['id'] as String?,
      dateTime: data['dateTime'] == null
          ? null
          : DateTime.parse(data['dateTime'] as String),
      numberOfTickets: data['numberOfTickets'] as int?,
      totalPrice: data['totalPrice'] as double?,
      eventId: data['eventId'] as String?,
      author: data['author'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'dateTime': dateTime?.toIso8601String(),
        'numberOfTickets': numberOfTickets,
        'totalPrice': totalPrice,
        'eventId': eventId,
        'author': author,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PurchaseResponse].
  factory PurchaseResponse.fromJson(String data) {
    return PurchaseResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PurchaseResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}

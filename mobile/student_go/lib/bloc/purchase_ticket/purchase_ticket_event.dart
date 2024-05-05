part of 'purchase_ticket_bloc.dart';

@immutable
sealed class PurchaseTicketEvent {}

final class FetchPruchaseTicket extends PurchaseTicketEvent {
  final String id;
  FetchPruchaseTicket(this.id);
}

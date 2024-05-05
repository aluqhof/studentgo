part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseEvent {}

final class FetchPurchase extends PurchaseEvent {
  final String eventId;
  FetchPurchase(this.eventId);
}

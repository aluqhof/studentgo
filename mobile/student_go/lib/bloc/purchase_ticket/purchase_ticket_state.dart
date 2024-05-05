part of 'purchase_ticket_bloc.dart';

@immutable
sealed class PurchaseTicketState {}

final class PurchaseTicketInitial extends PurchaseTicketState {}

final class PurchaseTicketLoading extends PurchaseTicketState {}

final class PurchaseTicketSuccess extends PurchaseTicketState {
  final PurchaseTicketResponse purchaseTicket;
  PurchaseTicketSuccess(this.purchaseTicket);
}

final class PurchaseTicketError extends PurchaseTicketState {
  final String errorMessage;
  PurchaseTicketError(this.errorMessage);
}

final class PurchaseTicketEntityException extends PurchaseTicketError {
  final GeneralException generalException;
  PurchaseTicketEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidStatePurchaseTicket extends PurchaseTicketState {}

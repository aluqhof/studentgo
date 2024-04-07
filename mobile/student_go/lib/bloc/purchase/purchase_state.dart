part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseState {}

final class PurchaseInitial extends PurchaseState {}

final class PurchaseLoading extends PurchaseState {}

final class PurchaseSuccess extends PurchaseState {
  final PurchaseResponse purchase;
  PurchaseSuccess(this.purchase);
}

final class PurchaseError extends PurchaseState {
  final String errorMessagge;
  PurchaseError(this.errorMessagge);
}

final class PurchaseEntityException extends PurchaseError {
  final GeneralException generalException;
  PurchaseEntityException(this.generalException, String errorMessage)
      : super(errorMessage);
}

final class TokenNotValidState extends PurchaseState {}

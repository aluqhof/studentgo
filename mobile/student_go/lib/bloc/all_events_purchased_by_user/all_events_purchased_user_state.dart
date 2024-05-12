part of 'all_events_purchased_user_bloc.dart';

@immutable
sealed class AllEventsPurchasedUserState {}

final class AllEventsPurchasedUserInitial extends AllEventsPurchasedUserState {}

final class AllEventsPurchasedUserLoading extends AllEventsPurchasedUserState {}

final class AllEventsPurchasedUserSuccess extends AllEventsPurchasedUserState {
  final List<PurchaseOverviewResponse> purchases;
  AllEventsPurchasedUserSuccess(this.purchases);
}

final class AllEventsPurchasedUserError extends AllEventsPurchasedUserState {
  final String errorMessage;
  AllEventsPurchasedUserError(this.errorMessage);
}

final class TokenNotValidState extends AllEventsPurchasedUserState {}

final class AllEventsPurchasedUserEntityException
    extends AllEventsPurchasedUserError {
  final GeneralException generalException;
  AllEventsPurchasedUserEntityException(
      this.generalException, String errorMessage)
      : super(errorMessage);
}

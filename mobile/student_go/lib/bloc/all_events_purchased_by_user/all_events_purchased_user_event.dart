part of 'all_events_purchased_user_bloc.dart';

@immutable
sealed class AllEventsPurchasedUserEvent {}

final class FetchAllEventsPurchasedUser extends AllEventsPurchasedUserEvent {
  FetchAllEventsPurchasedUser();
}

part of 'change_username_bloc.dart';

@immutable
sealed class ChangeUsernameEvent {}

final class FetchUsernameChange extends ChangeUsernameEvent {
  final String newUsername;
  FetchUsernameChange(this.newUsername);
}

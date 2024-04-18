part of 'update_profile_bloc.dart';

@immutable
sealed class UpdateProfileEvent {}

final class FetchProfileUpdate extends UpdateProfileEvent {
  final String name;
  final String description;
  final List<int> interests;
  FetchProfileUpdate(this.name, this.description, this.interests);
}

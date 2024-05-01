part of 'profile_image_bloc.dart';

@immutable
sealed class ProfileImageEvent {}

final class FetchProfileImage extends ProfileImageEvent {
  FetchProfileImage();
}

final class FetchProfileImageById extends ProfileImageEvent {
  final String id;
  FetchProfileImageById(this.id);
}

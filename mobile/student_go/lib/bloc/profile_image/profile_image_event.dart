part of 'profile_image_bloc.dart';

@immutable
sealed class ProfileImageEvent {}

final class FetchProfileImage extends ProfileImageEvent {
  FetchProfileImage();
}

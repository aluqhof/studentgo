part of 'upload_profile_photo_bloc.dart';

@immutable
sealed class UploadProfilePhotoEvent {}

final class FetchProfilePhotoUpload extends UploadProfilePhotoEvent {
  final XFile image;
  FetchProfilePhotoUpload(this.image);
}

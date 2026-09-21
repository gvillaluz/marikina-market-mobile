import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class EditProfileSubmitted extends ProfileEvent {
  final int userId;
  final String lastName;
  final String firstName;
  final String? middleName;

  EditProfileSubmitted({
    required this.userId,
    required this.lastName,
    required this.firstName,
    this.middleName,
  });
}

class UpdatePasswordSubmitted extends ProfileEvent {
  final int userId;
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  UpdatePasswordSubmitted({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });
}

class ChangeProfilePhoto extends ProfileEvent {
  final XFile file;
  ChangeProfilePhoto({required this.file});
}

class RemoveProfilePhoto extends ProfileEvent {}

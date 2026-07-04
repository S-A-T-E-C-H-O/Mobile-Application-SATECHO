import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';

class EditProfileController extends ChangeNotifier {
  EditProfileController(this._repository);

  final UserProfileRepository _repository;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> updateProfile(String fullName) => _run(
        () => _repository.updateProfile(fullName: fullName),
      );

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _run(
        () => _repository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

  Future<bool> _run(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on Exception catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

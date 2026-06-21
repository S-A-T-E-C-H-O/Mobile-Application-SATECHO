import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/user_profile/domain/use_cases/get_user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/use_cases/logout_user.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(this._getUserProfile, this._logoutUser);

  final GetUserProfile _getUserProfile;
  final LogoutUser _logoutUser;

  bool isLoading = true;
  UserProfile? profile;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    profile = await _getUserProfile();
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() => _logoutUser();
}

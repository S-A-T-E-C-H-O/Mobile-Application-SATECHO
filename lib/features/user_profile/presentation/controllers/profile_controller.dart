import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/session/session_manager.dart';
import 'package:satecho_mobile/features/user_profile/domain/use_cases/get_user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(this._getUserProfile, {SessionManager? sessionManager})
      : _sessionManager = sessionManager;

  final GetUserProfile _getUserProfile;
  final SessionManager? _sessionManager;

  bool isLoading = true;
  UserProfile? profile;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    profile = await _getUserProfile();
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() => _sessionManager?.logout() ?? Future<void>.value();
}

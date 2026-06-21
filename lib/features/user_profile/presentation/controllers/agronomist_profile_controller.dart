import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/user_profile/domain/use_cases/get_agronomist_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile.dart';

class AgronomistProfileController extends ChangeNotifier {
  AgronomistProfileController(this._getProfile);

  final GetAgronomistProfile _getProfile;

  bool isLoading = true;
  AgronomistProfile? profile;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    profile = await _getProfile();
    isLoading = false;
    notifyListeners();
  }
}

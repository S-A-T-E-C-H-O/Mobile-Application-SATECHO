import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> logout();
}

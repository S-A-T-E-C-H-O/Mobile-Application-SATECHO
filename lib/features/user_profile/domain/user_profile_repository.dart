import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile({required String fullName});
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';

class MockUserProfileRepository implements UserProfileRepository {
  @override
  Future<UserProfile> getProfile() async {
    return const UserProfile(
      id: 'user-1',
      name: 'Juan Pérez',
      farmName: 'El Porvenir',
      farmAreaLabel: '240 ha',
      photoUrl: '',
      notificationPreference: 'All active',
      units: 'Metric',
      offlineMode: 'Automatic',
      language: 'Spanish',
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> updateProfile({required String fullName}) async {}

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}
}

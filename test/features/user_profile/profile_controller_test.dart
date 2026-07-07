import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/core/session/session_manager.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';
import 'package:satecho_mobile/features/user_profile/domain/use_cases/get_user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';
import 'package:satecho_mobile/features/user_profile/presentation/controllers/profile_controller.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}

class _FakeUserProfileRepository implements UserProfileRepository {
  @override
  Future<UserProfile> getProfile() async => const UserProfile(
        id: 'u1',
        name: 'Test Farmer',
        farmName: 'Farm',
        farmAreaLabel: '1 ha',
        photoUrl: '',
        notificationPreference: 'All',
        units: 'Metric',
        offlineMode: 'Disabled',
        language: 'English',
      );

  @override
  Future<void> updateProfile({required String fullName}) async {}

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}
}

void main() {
  group('ProfileController.logout', () {
    test(
        'delegates to SessionManager.logout(), the single logout source '
        'of truth', () async {
      final tokenStorage = TokenStorage(_FakeSecureStorage());
      await tokenStorage.saveToken('abc123');
      final sessionManager = SessionManager(tokenStorage: tokenStorage);
      var expiredCalls = 0;
      sessionManager.onSessionExpired = () => expiredCalls++;

      final controller = ProfileController(
        GetUserProfile(_FakeUserProfileRepository()),
        sessionManager: sessionManager,
      );

      await controller.logout();

      expect(await tokenStorage.readToken(), isNull);
      expect(expiredCalls, 1);
    });

    test('is a safe no-op when no SessionManager is attached', () async {
      final controller =
          ProfileController(GetUserProfile(_FakeUserProfileRepository()));

      await expectLater(controller.logout(), completes);
    });
  });
}

import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';
import 'package:satecho_mobile/features/auth/data/auth_local_data_source.dart';
import 'package:satecho_mobile/features/user_profile/data/user_profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl({
    required UserProfileRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final UserProfileRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<UserProfile> getProfile() async {
    final user = await _remote.getMe();
    final farms = await _remote.getFarms();
    final farm = farms.isNotEmpty ? farms.first : null;

    return UserProfile(
      id: user.id.toString(),
      name: user.fullName,
      farmName: farm?.name ?? 'No farm',
      farmAreaLabel: farm != null ? '${farm.id} ha' : '—',
      photoUrl: '',
      notificationPreference: 'All notifications',
      units: 'Metric',
      offlineMode: 'Disabled',
      language: 'English',
    );
  }

  @override
  Future<void> logout() => _local.clearSession();

  @override
  Future<void> updateProfile({required String fullName}) =>
      _remote.updateProfile(fullName: fullName);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}

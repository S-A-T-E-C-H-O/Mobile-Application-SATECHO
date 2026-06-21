import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile_repository.dart';
import 'package:satecho_mobile/features/user_profile/data/user_profile_remote_data_source.dart';

class AgronomistProfileRepositoryImpl implements AgronomistProfileRepository {
  const AgronomistProfileRepositoryImpl(this._remote);

  final UserProfileRemoteDataSource _remote;

  @override
  Future<AgronomistProfile> getAgronomistProfile() async {
    try {
      final user = await _remote.getMe();
      final farms = await _remote.getFarms();
      return AgronomistProfile(
        name: user.fullName,
        roleLabel: 'Agricultural Engineer',
        activeClients: farms.length,
        phone: '',
        email: user.email,
        base: '',
        rating: 0.0,
        experienceLabel: '',
        specialties: const [],
        areasServed: const [],
      );
    } catch (_) {
      return const AgronomistProfile(
        name: 'Agronomist',
        roleLabel: 'Agricultural Engineer',
        activeClients: 0,
        phone: '',
        email: '',
        base: '',
        rating: 0.0,
        experienceLabel: '',
        specialties: [],
        areasServed: [],
      );
    }
  }
}

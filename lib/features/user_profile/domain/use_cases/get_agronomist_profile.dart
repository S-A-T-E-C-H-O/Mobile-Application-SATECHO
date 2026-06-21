import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile_repository.dart';

class GetAgronomistProfile {
  const GetAgronomistProfile(this._repository);

  final AgronomistProfileRepository _repository;

  Future<AgronomistProfile> call() => _repository.getAgronomistProfile();
}

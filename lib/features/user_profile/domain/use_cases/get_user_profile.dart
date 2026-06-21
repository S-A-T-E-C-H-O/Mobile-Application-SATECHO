import 'package:satecho_mobile/features/user_profile/domain/user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';

class GetUserProfile {
  const GetUserProfile(this._repository);

  final UserProfileRepository _repository;

  Future<UserProfile> call() => _repository.getProfile();
}

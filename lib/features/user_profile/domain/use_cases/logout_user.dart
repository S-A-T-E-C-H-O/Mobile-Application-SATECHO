import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';

class LogoutUser {
  const LogoutUser(this._repository);

  final UserProfileRepository _repository;

  Future<void> call() => _repository.logout();
}

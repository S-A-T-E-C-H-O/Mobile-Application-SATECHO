import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';

class ClearSession {
  const ClearSession(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.clearSession();
}

import '../../domain/entities/onboarding_progress.dart';
import '../../domain/repositories/onboarding_repository.dart';

class GetOnboardingProgress {
  const GetOnboardingProgress(this._repository);

  final OnboardingRepository _repository;

  Future<OnboardingProgress> call() => _repository.getProgress();
}

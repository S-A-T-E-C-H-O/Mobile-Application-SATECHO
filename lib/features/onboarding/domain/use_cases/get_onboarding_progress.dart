import 'package:satecho_mobile/features/onboarding/domain/onboarding_progress.dart';
import 'package:satecho_mobile/features/onboarding/domain/onboarding_repository.dart';

class GetOnboardingProgress {
  const GetOnboardingProgress(this._repository);

  final OnboardingRepository _repository;

  Future<OnboardingProgress> call() => _repository.getProgress();
}

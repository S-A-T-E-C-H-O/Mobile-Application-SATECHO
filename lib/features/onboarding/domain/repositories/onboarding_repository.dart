import '../entities/onboarding_progress.dart';

abstract class OnboardingRepository {
  Future<OnboardingProgress> getProgress();
  Future<void> completeOnboarding(Map<String, dynamic> data);
  Future<List<String>> getCropTypeNames();
}

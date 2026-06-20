import 'package:satecho_mobile/features/onboarding/domain/onboarding_progress.dart';
import 'package:satecho_mobile/features/onboarding/domain/onboarding_repository.dart';

class MockOnboardingRepository implements OnboardingRepository {
  @override
  Future<OnboardingProgress> getProgress() async {
    return const OnboardingProgress(completed: true);
  }

  @override
  Future<void> completeOnboarding(Map<String, dynamic> data) async {}

  @override
  Future<List<String>> getCropTypeNames() async {
    return const [
      'CORN', 'SOYBEAN', 'WHEAT', 'COFFEE', 'AVOCADO',
      'TOMATO', 'LETTUCE', 'BLUEBERRY', 'RICE', 'POTATO',
    ];
  }
}

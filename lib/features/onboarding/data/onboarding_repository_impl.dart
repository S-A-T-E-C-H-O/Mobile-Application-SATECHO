import 'package:satecho_mobile/features/onboarding/domain/onboarding_progress.dart';
import 'package:satecho_mobile/features/onboarding/domain/onboarding_repository.dart';
import 'package:satecho_mobile/features/onboarding/data/onboarding_remote_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._remote);

  final OnboardingRemoteDataSource _remote;

  @override
  Future<OnboardingProgress> getProgress() async {
    final model = await _remote.getStatus();
    return OnboardingProgress(completed: model.completed);
  }

  @override
  Future<void> completeOnboarding(Map<String, dynamic> data) async {
    await _remote.createFarm({
      'name': data['farmName'],
      'location': data['location'],
      'hectares': data['hectares'],
      'cropType': data['cropType'],
      'zones': [
        {
          'name': data['zoneName'] ?? 'Main Zone',
          'areaHectares': data['hectares'],
          'cropType': data['cropType'],
        }
      ],
    });
    await _remote.complete({});
  }

  @override
  Future<List<String>> getCropTypeNames() async {
    final types = await _remote.getCropTypes();
    return types
        .map((t) => (t['name'] as String?) ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
  }
}

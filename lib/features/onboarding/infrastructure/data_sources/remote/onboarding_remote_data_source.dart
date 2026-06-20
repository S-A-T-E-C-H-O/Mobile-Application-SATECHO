import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/onboarding_status_model.dart';

class OnboardingRemoteDataSource {
  const OnboardingRemoteDataSource(this._client);

  final ApiClient _client;

  Future<OnboardingStatusModel> getStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.onboardingStatus,
    );
    return OnboardingStatusModel.fromJson(response.data!);
  }

  Future<void> createFarm(Map<String, dynamic> data) async {
    await _client.post<void>(ApiConstants.farms, data: data);
  }

  Future<void> complete(Map<String, dynamic> data) async {
    await _client.post<void>(ApiConstants.onboardingComplete, data: data);
  }

  Future<List<Map<String, dynamic>>> getCropTypes() async {
    try {
      final response =
      await _client.get<List<dynamic>>('/api/v1/crops/types');
      return (response.data as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (_) {
      return [];
    }
  }
}

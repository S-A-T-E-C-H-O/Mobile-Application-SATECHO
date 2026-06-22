import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/advisory/data/recommendation_model.dart';

class RecommendationRemoteDataSource {
  const RecommendationRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<RecommendationModel>> getRecommendations() async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.recommendations,
    );
    return (response.data as List<dynamic>)
        .map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> acknowledge(String recommendationId) async {
    await _client.patch<void>(
      ApiConstants.acknowledgeRecommendation(recommendationId),
    );
  }

  Future<void> dismiss(String recommendationId) async {
    await _client.patch<void>(
      ApiConstants.dismissRecommendation(recommendationId),
    );
  }
}

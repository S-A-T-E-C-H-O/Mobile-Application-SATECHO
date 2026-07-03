import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/billing/data/subscription_model.dart';

class SubscriptionRemoteDataSource {
  const SubscriptionRemoteDataSource(this._client);

  final ApiClient _client;

  Future<SubscriptionModel?> getCurrentSubscription() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiConstants.mySubscription,
      );
      if (response.statusCode == 204 || response.data == null) return null;
      return SubscriptionModel.fromJson(response.data!);
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getPlans() async {
    final response =
        await _client.get<List<dynamic>>(ApiConstants.subscriptionPlans);
    return (response.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<List<Map<String, dynamic>>> getInvoices() async {
    final response = await _client.get<List<dynamic>>(ApiConstants.myInvoices);
    return (response.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<void> subscribe(String planTier) async {
    await _client.post<void>(
      ApiConstants.mySubscription,
      data: {'planTier': planTier},
    );
  }

  Future<void> cancel() async {
    await _client.post<void>('${ApiConstants.mySubscription}/cancel');
  }
}

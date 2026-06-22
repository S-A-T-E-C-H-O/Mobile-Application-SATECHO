import 'package:satecho_mobile/features/billing/domain/subscription.dart';
import 'package:satecho_mobile/features/billing/domain/subscription_repository.dart';

class MockSubscriptionRepository implements SubscriptionRepository {
  @override
  Future<Subscription?> getCurrentSubscription() async => null;
}

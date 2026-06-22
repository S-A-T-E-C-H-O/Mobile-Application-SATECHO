import 'package:satecho_mobile/features/billing/domain/subscription.dart';

abstract class SubscriptionRepository {
  Future<Subscription?> getCurrentSubscription();
}

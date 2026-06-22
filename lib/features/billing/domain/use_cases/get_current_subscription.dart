import 'package:satecho_mobile/features/billing/domain/subscription.dart';
import 'package:satecho_mobile/features/billing/domain/subscription_repository.dart';

class GetCurrentSubscription {
  const GetCurrentSubscription(this._repository);

  final SubscriptionRepository _repository;

  Future<Subscription?> call() => _repository.getCurrentSubscription();
}

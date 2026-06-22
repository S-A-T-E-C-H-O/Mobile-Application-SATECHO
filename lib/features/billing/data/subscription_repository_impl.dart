import 'package:satecho_mobile/features/billing/domain/subscription.dart';
import 'package:satecho_mobile/features/billing/domain/subscription_repository.dart';
import 'package:satecho_mobile/features/billing/data/subscription_remote_data_source.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  const SubscriptionRepositoryImpl(this._remote);

  final SubscriptionRemoteDataSource _remote;

  @override
  Future<Subscription?> getCurrentSubscription() async {
    final model = await _remote.getCurrentSubscription();
    if (model == null) return null;
    return Subscription(
      id: model.id.toString(),
      planName: '${model.planType} · ${model.billingCycle}',
    );
  }
}

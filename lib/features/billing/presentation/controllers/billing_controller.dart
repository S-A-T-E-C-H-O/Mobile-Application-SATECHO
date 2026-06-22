import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/billing/domain/use_cases/get_current_subscription.dart';
import 'package:satecho_mobile/features/billing/domain/subscription.dart';
import 'package:satecho_mobile/features/billing/data/subscription_remote_data_source.dart';

class BillingController extends ChangeNotifier {
  BillingController(this._getSubscription, {SubscriptionRemoteDataSource? remote})
      : _remote = remote;

  final GetCurrentSubscription _getSubscription;
  final SubscriptionRemoteDataSource? _remote;

  Subscription? _subscription;
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> plans = [];
  List<Map<String, dynamic>> invoices = [];

  Subscription? get subscription => _subscription;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscription = await _getSubscription();
      final remote = _remote;
      if (remote != null) {
        final results = await Future.wait([
          remote.getPlans().catchError((_) => <Map<String, dynamic>>[]),
          remote.getInvoices().catchError((_) => <Map<String, dynamic>>[]),
        ]);
        plans = results[0];
        invoices = results[1];
      }
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

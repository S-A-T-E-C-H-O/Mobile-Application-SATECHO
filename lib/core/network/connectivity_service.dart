import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper over connectivity_plus so features depend on a small
/// interface instead of the plugin directly (same pattern as TokenStorage).
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(_hasConnection);

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}

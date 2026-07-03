import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/network/connectivity_service.dart';
import 'package:satecho_mobile/core/storage/local_cache.dart';
import 'package:satecho_mobile/features/analytics/domain/use_cases/get_farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/domain/weather_summary.dart';

/// EP-004-US001 Scenario 2: no-connection shows the last cached KPI snapshot
/// with an "Offline mode" indicator instead of a blank/error screen.
class DashboardController extends ChangeNotifier {
  DashboardController(
    this._getFarmerDashboard, {
    ConnectivityService? connectivity,
    LocalCache? localCache,
  })  : _connectivity = connectivity,
        _localCache = localCache;

  static const _cacheKey = 'dashboard_kpi_snapshot';

  final GetFarmerDashboard _getFarmerDashboard;
  final ConnectivityService? _connectivity;
  final LocalCache? _localCache;

  bool isLoading = true;
  bool isOffline = false;
  FarmerDashboard? dashboard;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final online = await (_connectivity?.isOnline() ?? Future.value(true));
    if (!online) {
      dashboard = await _loadCached();
      isOffline = true;
      isLoading = false;
      notifyListeners();
      return;
    }

    dashboard = await _getFarmerDashboard();
    isOffline = false;
    unawaited(_saveCache());
    isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCache() async {
    final d = dashboard;
    final kpis = d?.kpis;
    if (d == null || kpis == null || _localCache == null) return;
    await _localCache.putJson(_cacheKey, {
      'farmName': d.farmName,
      'totalZones': kpis.totalZones,
      'onlineDevices': kpis.onlineDevices,
      'offlineDevices': kpis.offlineDevices,
      'criticalAlerts': kpis.criticalAlerts,
      'avgMoisture7d': kpis.avgMoisture7d,
      'avgEc7d': kpis.avgEc7d,
      'weeklyIrrigationHours': kpis.weeklyIrrigationHours,
      'criticalMoisture': kpis.criticalMoisture,
    });
  }

  Future<FarmerDashboard?> _loadCached() async {
    final cache = _localCache;
    if (cache == null) return null;
    final json = await cache.getJson(_cacheKey);
    if (json == null) return null;
    return FarmerDashboard(
      greeting: 'Welcome back',
      farmName: json['farmName'] as String? ?? 'My Farm',
      weather: const WeatherSummary(
          temperature: 0, condition: 'Unavailable offline', hasAlert: false),
      plots: const [],
      upcomingIrrigations: const [],
      activeAlerts: const [],
      kpis: FarmerKpis(
        totalZones: json['totalZones'] as int? ?? 0,
        onlineDevices: json['onlineDevices'] as int? ?? 0,
        offlineDevices: json['offlineDevices'] as int? ?? 0,
        criticalAlerts: json['criticalAlerts'] as int? ?? 0,
        avgMoisture7d: (json['avgMoisture7d'] as num?)?.toDouble(),
        avgEc7d: (json['avgEc7d'] as num?)?.toDouble(),
        weeklyIrrigationHours:
            (json['weeklyIrrigationHours'] as num?)?.toDouble(),
        criticalMoisture: json['criticalMoisture'] as bool? ?? false,
      ),
    );
  }
}

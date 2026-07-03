import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/network/connectivity_service.dart';
import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/core/storage/local_cache.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/use_cases/get_plots.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/get_current_irrigation_session.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/get_irrigation_history.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/start_irrigation.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/stop_irrigation.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_session.dart';

class IrrigationController extends ChangeNotifier {
  IrrigationController({
    required GetPlots getPlots,
    required GetCurrentIrrigationSession getSession,
    required StartIrrigation startIrrigation,
    required StopIrrigation stopIrrigation,
    required GetIrrigationHistory getHistory,
    RealtimeService? realtime,
    ConnectivityService? connectivity,
    LocalCache? localCache,
  })  : _getPlots = getPlots,
        _getSession = getSession,
        _startIrrigation = startIrrigation,
        _stopIrrigation = stopIrrigation,
        _getHistory = getHistory,
        _realtime = realtime,
        _connectivity = connectivity,
        _localCache = localCache {
    _connSub = _connectivity?.onConnectivityChanged.listen((online) {
      if (online) _drainPendingCommand();
    });
  }

  static const _pendingKey = 'irrigation_pending_command';

  final GetPlots _getPlots;
  final GetCurrentIrrigationSession _getSession;
  final StartIrrigation _startIrrigation;
  final StopIrrigation _stopIrrigation;
  final GetIrrigationHistory _getHistory;
  final RealtimeService? _realtime;
  final ConnectivityService? _connectivity;
  final LocalCache? _localCache;
  StreamSubscription<bool>? _connSub;

  StreamSubscription<RealtimeEvent>? _irrigationSub;
  StreamSubscription<RealtimeEvent>? _sensorSub;

  bool isLoading = true;
  List<Plot> plots = [];
  Plot? selectedPlot;
  IrrigationSession? session;
  int selectedDuration = 15;
  List<Map<String, dynamic>> history = [];
  String? offlineNotice;

  Future<void> load({String? initialPlotId}) async {
    isLoading = true;
    notifyListeners();
    plots = await _getPlots();
    selectedPlot =
        plots.where((plot) => plot.id == initialPlotId).firstOrNull ??
            plots.firstOrNull;
    if (selectedPlot != null) {
      session = await _getSession(selectedPlot!.id);
      selectedDuration = session?.selectedDurationMinutes ?? 15;
      history = await _getHistory(selectedPlot!.id);
    }
    isLoading = false;
    notifyListeners();
    _subscribeToStreams();
  }

  Future<void> selectPlot(Plot plot) async {
    selectedPlot = plot;
    session = await _getSession(plot.id);
    selectedDuration = session?.selectedDurationMinutes ?? selectedDuration;
    history = await _getHistory(plot.id);
    notifyListeners();
    _subscribeToStreams();
  }

  void selectDuration(int minutes) {
    selectedDuration = minutes;
    notifyListeners();
  }

  Future<void> toggle() async {
    final plot = selectedPlot;
    if (plot == null) return;
    final action = (session?.isRunning ?? false) ? 'STOP' : 'START';
    if (!await _isOnline()) {
      await _queueCommand(plot.id, action);
      return;
    }
    if (action == 'STOP') {
      session = await _stopIrrigation(plot.id);
    } else {
      session = await _startIrrigation(plot.id, selectedDuration);
    }
    notifyListeners();
  }

  Future<void> activateIrrigation() async {
    final plot = selectedPlot;
    if (plot == null) return;
    if (!await _isOnline()) {
      await _queueCommand(plot.id, 'START');
      return;
    }
    session = await _startIrrigation(plot.id, selectedDuration);
    notifyListeners();
  }

  Future<bool> _isOnline() async =>
      _connectivity == null ? true : _connectivity.isOnline();

  /// EP-004-US002 Scenario 3: no network — persist the command locally and
  /// notify the farmer it'll be retried once connectivity returns.
  Future<void> _queueCommand(String plotId, String action) async {
    final cache = _localCache;
    if (cache != null) {
      await cache.putJson(_pendingKey,
          {'plotId': plotId, 'action': action, 'duration': selectedDuration});
    }
    offlineNotice =
        'No connection — the ${action.toLowerCase()} command will be sent when you\'re back online.';
    notifyListeners();
  }

  Future<void> _drainPendingCommand() async {
    final cache = _localCache;
    if (cache == null) return;
    final pending = await cache.getJson(_pendingKey);
    if (pending == null) return;
    await cache.remove(_pendingKey);
    final plotId = pending['plotId'] as String?;
    final action = pending['action'] as String?;
    final duration = pending['duration'] as int? ?? selectedDuration;
    if (plotId == null || action == null) return;
    session = action == 'STOP'
        ? await _stopIrrigation(plotId)
        : await _startIrrigation(plotId, duration);
    offlineNotice = null;
    notifyListeners();
  }

  void _subscribeToStreams() {
    _irrigationSub?.cancel();
    _sensorSub?.cancel();

    final realtime = _realtime;
    final plot = selectedPlot;
    if (realtime == null || plot == null) return;

    _irrigationSub = realtime.irrigationStatus(plot.id).listen((event) {
      if (event.irrigationRunning != null) {
        _refreshSession();
      }
    });

    _sensorSub = realtime.sensorReadings(plot.id).listen((event) {
      if (event.sensorMetric != null) {
        final metric = event.sensorMetric!;
        final updated = selectedPlot;
        if (updated != null) {
          final newMetrics = updated.metrics
              .where((m) => m.type != metric.type)
              .followedBy([metric]).toList();
          selectedPlot = Plot(
            id: updated.id,
            name: updated.name,
            crop: updated.crop,
            lastActivityLabel: updated.lastActivityLabel,
            status: updated.status,
            metrics: newMetrics,
          );
          notifyListeners();
        }
      }
    });
  }

  Future<void> _refreshSession() async {
    final plot = selectedPlot;
    if (plot == null) return;
    session = await _getSession(plot.id);
    notifyListeners();
  }

  @override
  void dispose() {
    _irrigationSub?.cancel();
    _sensorSub?.cancel();
    _connSub?.cancel();
    super.dispose();
  }
}

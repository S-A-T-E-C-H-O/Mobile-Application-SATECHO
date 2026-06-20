import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
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
  })  : _getPlots = getPlots,
        _getSession = getSession,
        _startIrrigation = startIrrigation,
        _stopIrrigation = stopIrrigation,
        _getHistory = getHistory,
        _realtime = realtime;

  final GetPlots _getPlots;
  final GetCurrentIrrigationSession _getSession;
  final StartIrrigation _startIrrigation;
  final StopIrrigation _stopIrrigation;
  final GetIrrigationHistory _getHistory;
  final RealtimeService? _realtime;

  StreamSubscription<RealtimeEvent>? _irrigationSub;
  StreamSubscription<RealtimeEvent>? _sensorSub;

  bool isLoading = true;
  List<Plot> plots = [];
  Plot? selectedPlot;
  IrrigationSession? session;
  int selectedDuration = 15;
  List<Map<String, dynamic>> history = [];

  Future<void> load({String? initialPlotId}) async {
    isLoading = true;
    notifyListeners();
    plots = await _getPlots();
    selectedPlot = plots
        .where((plot) => plot.id == initialPlotId)
        .firstOrNull ??
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
    if (session?.isRunning ?? false) {
      session = await _stopIrrigation(plot.id);
    } else {
      session = await _startIrrigation(plot.id, selectedDuration);
    }
    notifyListeners();
  }

  Future<void> activateIrrigation() async {
    final plot = selectedPlot;
    if (plot == null) return;
    session = await _startIrrigation(plot.id, selectedDuration);
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
              .followedBy([metric])
              .toList();
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
    super.dispose();
  }
}

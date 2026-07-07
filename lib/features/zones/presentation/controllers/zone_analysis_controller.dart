import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/zones/data/zone_remote_data_source.dart';
import 'package:satecho_mobile/features/zones/domain/soil_reading_point.dart';
import 'package:satecho_mobile/features/zones/domain/use_cases/get_zone_by_id.dart';
import 'package:satecho_mobile/features/zones/domain/zone.dart';

class ZoneAnalysisController extends ChangeNotifier {
  ZoneAnalysisController(this._getZoneById, this._remote);

  final GetZoneById _getZoneById;
  final ZoneRemoteDataSource? _remote;

  static const _periods = [
    Duration(hours: 24),
    Duration(days: 7),
    Duration(days: 30),
    Duration(days: 90),
  ];
  static const metrics = [
    ('SOIL_MOISTURE', 'Humidity', '%'),
    ('ELECTRICAL_CONDUCTIVITY', 'Electrical Conductivity (EC)', ' dS/m'),
    ('SOIL_TEMPERATURE', 'Soil Temperature', '°C'),
    ('AMBIENT_TEMPERATURE', 'Ambient Temperature', '°C'),
  ];

  bool isLoading = true;
  Zone? zone;
  String? _zoneId;
  int periodIndex = 1;
  final Map<String, List<SoilReadingPoint>> series = {};

  Future<void> load(String zoneId) async {
    _zoneId = zoneId;
    isLoading = true;
    notifyListeners();
    zone = await _getZoneById(zoneId);
    await _loadSeries();
    isLoading = false;
    notifyListeners();
  }

  Future<void> setPeriod(int index) async {
    periodIndex = index;
    notifyListeners();
    await _loadSeries();
    notifyListeners();
  }

  Future<void> _loadSeries() async {
    final remote = _remote;
    final zoneId = _zoneId;
    if (remote == null || zoneId == null) return;
    final to = DateTime.now();
    final from = to.subtract(_periods[periodIndex]);
    for (final (metric, _, _) in metrics) {
      final rows =
          await remote.getHistory(zoneId, metric: metric, from: from, to: to);
      series[metric] = rows
          .map((json) {
            final ts = DateTime.tryParse(json['timestamp'] as String? ?? '');
            final value = (json['value'] as num?)?.toDouble();
            if (ts == null || value == null) return null;
            return SoilReadingPoint(timestamp: ts, value: value);
          })
          .whereType<SoilReadingPoint>()
          .toList();
    }
  }
}

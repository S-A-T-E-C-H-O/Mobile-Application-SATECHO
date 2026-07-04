import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/farm_model.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/sensor_reading_model.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/zone_with_thresholds_model.dart';

class ZoneWithTelemetry {
  const ZoneWithTelemetry({required this.zone, required this.readings});

  final ZoneModel zone;
  final List<SensorReadingModel> readings;
}

class PlotRemoteDataSource {
  const PlotRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<ZoneWithTelemetry>> fetchAllZonesWithTelemetry() async {
    final farmsResponse = await _client.get<List<dynamic>>(ApiConstants.farms);
    final farms = (farmsResponse.data as List<dynamic>)
        .map((e) => FarmModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final allZones = (await Future.wait(farms.map((farm) async {
      final zonesResponse = await _client.get<List<dynamic>>(
        ApiConstants.farmZones(farm.id.toString()),
      );
      return (zonesResponse.data as List<dynamic>)
          .map((e) => ZoneModel.fromJson(e as Map<String, dynamic>))
          .toList();
    })))
        .expand((zones) => zones)
        .toList();

    final telemetryFutures = allZones.map((zone) async {
      final readings = await _fetchReadings(zone.id.toString());
      return ZoneWithTelemetry(zone: zone, readings: readings);
    });

    return (await Future.wait(telemetryFutures)).toList();
  }

  Future<ZoneWithTelemetry?> fetchZoneWithTelemetry(String zoneId) async {
    try {
      final zoneResponse = await _client.get<Map<String, dynamic>>(
        ApiConstants.zone(zoneId),
      );
      final zone = ZoneModel.fromJson(zoneResponse.data!);
      final readings = await _fetchReadings(zoneId);
      return ZoneWithTelemetry(zone: zone, readings: readings);
    } catch (_) {
      return null;
    }
  }

  Future<List<SensorReadingModel>> _fetchReadings(String zoneId) async {
    try {
      final response = await _client.get<List<dynamic>>(
        ApiConstants.zoneLatestTelemetry(zoneId),
      );
      return (response.data as List<dynamic>)
          .map((e) => SensorReadingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

import 'package:satecho_mobile/features/parcel_comparison/data/parcel_comparison_remote_data_source.dart';
import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison.dart';
import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison_repository.dart';

class ParcelComparisonRepositoryImpl implements ParcelComparisonRepository {
  const ParcelComparisonRepositoryImpl(this._remote);

  final ParcelComparisonRemoteDataSource _remote;

  @override
  Future<List<ParcelComparison>> compare(List<int> zoneIds) async {
    final rows = await _remote.compare(zoneIds);
    return rows
        .map((json) => ParcelComparison(
              zoneId: json['zoneId'] as int,
              zoneName: json['zoneName'] as String?,
              soilMoisture: (json['soilMoisture'] as num?)?.toDouble(),
              soilTemperature: (json['soilTemperature'] as num?)?.toDouble(),
              electricalConductivity:
                  (json['electricalConductivity'] as num?)?.toDouble(),
              areaHectares: (json['areaHectares'] as num?)?.toDouble(),
              cropType: json['cropType'] as String?,
            ))
        .toList();
  }
}

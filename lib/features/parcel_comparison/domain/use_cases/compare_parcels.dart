import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison.dart';
import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison_repository.dart';

class CompareParcels {
  const CompareParcels(this._repository);

  final ParcelComparisonRepository _repository;

  Future<List<ParcelComparison>> call(List<int> zoneIds) =>
      _repository.compare(zoneIds);
}

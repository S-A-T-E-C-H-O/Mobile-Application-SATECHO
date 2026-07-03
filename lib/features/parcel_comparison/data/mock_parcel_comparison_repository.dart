import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison.dart';
import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison_repository.dart';

class MockParcelComparisonRepository implements ParcelComparisonRepository {
  @override
  Future<List<ParcelComparison>> compare(List<int> zoneIds) async => const [];
}

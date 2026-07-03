import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison.dart';

abstract class ParcelComparisonRepository {
  /// [zoneIds] must have between 1 and 4 entries (EP-012-US027).
  Future<List<ParcelComparison>> compare(List<int> zoneIds);
}

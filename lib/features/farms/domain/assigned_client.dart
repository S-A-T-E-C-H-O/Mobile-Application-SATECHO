import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'farm.dart';
import 'visit_history_item.dart';

class AssignedClient {
  const AssignedClient({
    required this.farm,
    required this.zones,
    required this.visitHistory,
  });

  final Farm farm;
  final List<Zone> zones;
  final List<VisitHistoryItem> visitHistory;
}

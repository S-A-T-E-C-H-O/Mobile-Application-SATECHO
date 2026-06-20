import '../entities/irrigation_session.dart';
import '../entities/upcoming_irrigation.dart';

abstract class IrrigationRepository {
  Future<IrrigationSession> getCurrentSession(String plotId);
  Future<IrrigationSession> startIrrigation(String plotId, int durationMinutes);
  Future<IrrigationSession> stopIrrigation(String plotId);
  Future<List<UpcomingIrrigation>> getUpcomingIrrigations();
  Future<List<Map<String, dynamic>>> getHistory(String zoneId);
}

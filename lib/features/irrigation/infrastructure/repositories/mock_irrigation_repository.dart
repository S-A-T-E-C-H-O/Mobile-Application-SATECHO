import '../../domain/entities/irrigation_session.dart';
import '../../domain/entities/upcoming_irrigation.dart';
import '../../domain/repositories/irrigation_repository.dart';
import '../models/irrigation_session_model.dart';

class MockIrrigationRepository implements IrrigationRepository {
  final Map<String, IrrigationSession> _sessions = {
    'plot-1': IrrigationSessionModel.mock(
      plotId: 'plot-1',
      status: IrrigationSessionStatus.idle,
      selectedDurationMinutes: 15,
    ),
    'plot-2': IrrigationSessionModel.mock(
      plotId: 'plot-2',
      status: IrrigationSessionStatus.running,
      selectedDurationMinutes: 25,
      remainingMinutes: 12,
    ),
  };

  @override
  Future<IrrigationSession> getCurrentSession(String plotId) async {
    return _sessions[plotId] ?? IrrigationSessionModel.mock(plotId: plotId);
  }

  @override
  Future<List<UpcomingIrrigation>> getUpcomingIrrigations() async {
    return const [
      UpcomingIrrigation(
        id: 'irr-1',
        plotId: 'plot-2',
        plotName: 'Plot 2 Center',
        scheduleLabel: 'Today 6:00 PM',
        durationMinutes: 25,
        highlighted: true,
      ),
      UpcomingIrrigation(
        id: 'irr-2',
        plotId: 'lot-b',
        plotName: 'Lot B South',
        scheduleLabel: 'Tomorrow 06:00',
        durationMinutes: 30,
        highlighted: false,
      ),
    ];
  }

  @override
  Future<IrrigationSession> startIrrigation(
    String plotId,
    int durationMinutes,
  ) async {
    final session = IrrigationSession(
      plotId: plotId,
      status: IrrigationSessionStatus.running,
      selectedDurationMinutes: durationMinutes,
      remainingMinutes: durationMinutes,
    );
    _sessions[plotId] = session;
    return session;
  }

  @override
  Future<List<Map<String, dynamic>>> getHistory(String zoneId) async => [];

  @override
  Future<IrrigationSession> stopIrrigation(String plotId) async {
    final current = await getCurrentSession(plotId);
    final session = current.copyWith(
      status: IrrigationSessionStatus.idle,
      remainingMinutes: null,
    );
    _sessions[plotId] = session;
    return session;
  }
}

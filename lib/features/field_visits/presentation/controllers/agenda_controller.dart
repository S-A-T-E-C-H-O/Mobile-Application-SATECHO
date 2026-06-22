import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/field_visits/domain/use_cases/get_scheduled_visits.dart';
import 'package:satecho_mobile/features/field_visits/domain/scheduled_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_repository.dart';

class AgendaController extends ChangeNotifier {
  AgendaController(this._getScheduledVisits, this._repository);

  final GetScheduledVisits _getScheduledVisits;
  final FieldVisitRepository _repository;

  bool isLoading = true;
  bool isScheduling = false;
  List<ScheduledVisit> visits = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    visits = await _getScheduledVisits();
    isLoading = false;
    notifyListeners();
  }

  Future<bool> scheduleVisit({
    required int farmId,
    required DateTime scheduledAt,
    required String tag,
    required String noteTitle,
    required String noteBody,
    required bool urgent,
  }) async {
    isScheduling = true;
    notifyListeners();
    try {
      final visit = await _repository.scheduleVisit(
        farmId: farmId,
        scheduledAt: scheduledAt,
        tag: tag,
        noteTitle: noteTitle,
        noteBody: noteBody,
        urgent: urgent,
      );
      visits = [visit, ...visits];
      return true;
    } on Exception {
      return false;
    } finally {
      isScheduling = false;
      notifyListeners();
    }
  }
}

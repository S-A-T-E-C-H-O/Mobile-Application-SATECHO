import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/activity_log/domain/use_cases/save_activity_offline.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_draft.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';

class ActivityFlowController extends ChangeNotifier {
  ActivityFlowController(this._saveActivityOffline);

  final SaveActivityOffline _saveActivityOffline;

  ActivityType? selectedType;
  String plotId = 'plot-1';
  String plotName = 'Plot 1 North';
  bool isSaving = false;

  void selectType(ActivityType type) {
    selectedType = type;
    notifyListeners();
  }

  ActivityDraft? buildDraft() {
    final type = selectedType;
    if (type == null) return null;
    return ActivityDraft(
      plotId: plotId,
      plotName: plotName,
      type: type,
      dateTimeLabel: 'Now',
    );
  }

  Future<void> save() async {
    final draft = buildDraft();
    if (draft == null) return;
    isSaving = true;
    notifyListeners();
    await _saveActivityOffline(draft);
    isSaving = false;
    notifyListeners();
  }
}

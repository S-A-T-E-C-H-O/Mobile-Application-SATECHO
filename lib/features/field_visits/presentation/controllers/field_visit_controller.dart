import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/field_visits/domain/use_cases/save_field_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_draft.dart';

class FieldVisitController extends ChangeNotifier {
  FieldVisitController(this._saveFieldVisit);

  final SaveFieldVisit _saveFieldVisit;

  final Set<int> completed = {};
  String notes = '';
  bool saved = false;

  int get total => 6;

  void toggle(int index) {
    if (completed.contains(index)) {
      completed.remove(index);
    } else {
      completed.add(index);
    }
    notifyListeners();
  }

  void setNotes(String value) {
    notes = value;
  }

  Future<void> save() async {
    await _saveFieldVisit(
      FieldVisitDraft(
        visitId: 'visit-1',
        completedItems: completed,
        notes: notes,
      ),
    );
    saved = true;
    notifyListeners();
  }
}

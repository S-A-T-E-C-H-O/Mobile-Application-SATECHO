import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/field_visits/domain/use_cases/save_field_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_draft.dart';

class FieldVisitController extends ChangeNotifier {
  FieldVisitController(this._saveFieldVisit, {required this.visitId});

  final SaveFieldVisit _saveFieldVisit;
  final String visitId;

  final Set<int> completed = {};
  String notes = '';
  bool saved = false;
  double? latitude;
  double? longitude;
  String? photoBase64;

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

  void setLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  void setPhoto(String base64) {
    photoBase64 = base64;
    notifyListeners();
  }

  Future<void> save() async {
    await _saveFieldVisit(
      FieldVisitDraft(
        visitId: visitId,
        completedItems: completed,
        notes: notes,
        latitude: latitude,
        longitude: longitude,
        photoBase64: photoBase64,
      ),
    );
    saved = true;
    notifyListeners();
  }
}

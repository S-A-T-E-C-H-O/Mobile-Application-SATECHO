import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/priority_cases/domain/priority_case.dart';
import 'package:satecho_mobile/features/priority_cases/domain/use_cases/get_priority_cases.dart';

class PriorityCasesController extends ChangeNotifier {
  PriorityCasesController(this._getPriorityCases);

  final GetPriorityCases _getPriorityCases;

  bool isLoading = true;
  List<PriorityCase> cases = const [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    cases = await _getPriorityCases();
    isLoading = false;
    notifyListeners();
  }
}

import 'package:satecho_mobile/features/priority_cases/domain/priority_case.dart';

abstract class PriorityCasesRepository {
  Future<List<PriorityCase>> getPriorityCases();
}

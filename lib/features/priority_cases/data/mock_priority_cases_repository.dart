import 'package:satecho_mobile/features/priority_cases/domain/priority_case.dart';
import 'package:satecho_mobile/features/priority_cases/domain/priority_cases_repository.dart';

class MockPriorityCasesRepository implements PriorityCasesRepository {
  @override
  Future<List<PriorityCase>> getPriorityCases() async => const [];
}

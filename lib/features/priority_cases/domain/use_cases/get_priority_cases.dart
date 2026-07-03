import 'package:satecho_mobile/features/priority_cases/domain/priority_case.dart';
import 'package:satecho_mobile/features/priority_cases/domain/priority_cases_repository.dart';

class GetPriorityCases {
  const GetPriorityCases(this._repository);

  final PriorityCasesRepository _repository;

  Future<List<PriorityCase>> call() => _repository.getPriorityCases();
}

import 'package:satecho_mobile/features/priority_cases/data/priority_cases_remote_data_source.dart';
import 'package:satecho_mobile/features/priority_cases/domain/priority_case.dart';
import 'package:satecho_mobile/features/priority_cases/domain/priority_cases_repository.dart';

class PriorityCasesRepositoryImpl implements PriorityCasesRepository {
  const PriorityCasesRepositoryImpl(this._remote);

  final PriorityCasesRemoteDataSource _remote;

  @override
  Future<List<PriorityCase>> getPriorityCases() async {
    final rows = await _remote.getPriorityCases();
    return rows
        .map((json) => PriorityCase(
              alertId: json['alertId'] as int,
              farmerName: json['farmerName'] as String?,
              farmName: json['farmName'] as String?,
              alertType: json['alertType'] as String? ?? 'UNKNOWN',
              severity: json['severity'] as String? ?? 'MEDIUM',
              createdAt: json['createdAt'] != null
                  ? DateTime.tryParse(json['createdAt'] as String)
                  : null,
            ))
        .toList();
  }
}

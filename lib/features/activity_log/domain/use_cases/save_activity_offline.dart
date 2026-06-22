import 'package:satecho_mobile/features/activity_log/domain/activity_draft.dart';
import 'package:satecho_mobile/features/activity_log/domain/farm_activity.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_repository.dart';

class SaveActivityOffline {
  const SaveActivityOffline(this._repository);

  final ActivityRepository _repository;

  Future<FarmActivity> call(ActivityDraft draft) {
    return _repository.saveOffline(draft);
  }
}

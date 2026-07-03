import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/activity_log/data/activity_log_remote_data_source.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_log_entry.dart';

/// EP-004-US020: chronological system activity feed with type filter and
/// incremental (page-by-page) loading, matching the backend's paginated
/// GET /api/v1/activity-log contract.
class ActivityLogListController extends ChangeNotifier {
  ActivityLogListController(this._client)
      : _remote = _client != null ? ActivityLogRemoteDataSource(_client) : null;

  final ApiClient? _client;
  final ActivityLogRemoteDataSource? _remote;

  static const _pageSize = 100;

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int _page = 0;
  int? _farmId;
  String? typeFilter;
  List<ActivityLogEntry> entries = [];

  Future<void> load() async {
    isLoading = true;
    _page = 0;
    hasMore = true;
    notifyListeners();
    try {
      final remote = _remote;
      if (remote == null) {
        entries = const [];
        return;
      }
      _farmId ??= await _resolveFarmId();
      final farmId = _farmId;
      if (farmId == null) {
        entries = const [];
        return;
      }
      final rows = await remote.getActivityLog(
          farmId: farmId, type: typeFilter, page: 0);
      entries = rows.map(_toEntry).toList();
      hasMore = rows.length >= _pageSize;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setTypeFilter(String? type) async {
    typeFilter = type;
    await load();
  }

  Future<void> loadMore() async {
    final remote = _remote;
    final farmId = _farmId;
    if (remote == null || farmId == null || isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();
    try {
      final nextPage = _page + 1;
      final rows = await remote.getActivityLog(
          farmId: farmId, type: typeFilter, page: nextPage);
      entries = [...entries, ...rows.map(_toEntry)];
      hasMore = rows.length >= _pageSize;
      _page = nextPage;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<int?> _resolveFarmId() async {
    try {
      final response = await _client!.get<List<dynamic>>(ApiConstants.farms);
      final farms = response.data as List<dynamic>;
      if (farms.isEmpty) return null;
      return (farms.first as Map<String, dynamic>)['id'] as int?;
    } catch (_) {
      return null;
    }
  }

  ActivityLogEntry _toEntry(Map<String, dynamic> json) => ActivityLogEntry(
        id: json['id'] as int,
        type: json['type'] as String? ?? 'UNKNOWN',
        description: json['description'] as String? ?? '',
        occurredAt: DateTime.tryParse(json['occurredAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

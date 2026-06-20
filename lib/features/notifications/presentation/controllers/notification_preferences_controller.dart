import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/notifications/data/alert_remote_data_source.dart';

class NotificationPreferencesController extends ChangeNotifier {
  NotificationPreferencesController({AlertRemoteDataSource? remote})
      : _remote = remote;

  final AlertRemoteDataSource? _remote;

  bool _irrigationAlerts = true;
  bool _soilAlerts = true;
  bool _securityAlerts = true;
  bool _weatherAlerts = false;
  bool _systemAlerts = true;

  bool get irrigationAlerts => _irrigationAlerts;
  bool get soilAlerts => _soilAlerts;
  bool get securityAlerts => _securityAlerts;
  bool get weatherAlerts => _weatherAlerts;
  bool get systemAlerts => _systemAlerts;

  set irrigationAlerts(bool v) {
    _irrigationAlerts = v;
    notifyListeners();
  }

  set soilAlerts(bool v) {
    _soilAlerts = v;
    notifyListeners();
  }

  set securityAlerts(bool v) {
    _securityAlerts = v;
    notifyListeners();
  }

  set weatherAlerts(bool v) {
    _weatherAlerts = v;
    notifyListeners();
  }

  set systemAlerts(bool v) {
    _systemAlerts = v;
    notifyListeners();
  }

  bool _isLoading = false;
  bool _isSaving = false;
  String? _feedbackMessage;
  bool _isError = false;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get feedbackMessage => _feedbackMessage;
  bool get isError => _isError;

  Future<void> load() async {
    final remote = _remote;
    if (remote == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await remote.loadPreferences();
      if (prefs['irrigationAlerts'] is bool) {
        _irrigationAlerts = prefs['irrigationAlerts'] as bool;
      }
      if (prefs['soilAlerts'] is bool) {
        _soilAlerts = prefs['soilAlerts'] as bool;
      }
      if (prefs['securityAlerts'] is bool) {
        _securityAlerts = prefs['securityAlerts'] as bool;
      }
      if (prefs['weatherAlerts'] is bool) {
        _weatherAlerts = prefs['weatherAlerts'] as bool;
      }
      if (prefs['systemAlerts'] is bool) {
        _systemAlerts = prefs['systemAlerts'] as bool;
      }
    } on Exception {
      // keep defaults if load fails
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save() async {
    final remote = _remote;
    if (remote == null) {
      _feedbackMessage = 'Preferences saved';
      _isError = false;
      notifyListeners();
      return;
    }

    _isSaving = true;
    _feedbackMessage = null;
    notifyListeners();

    try {
      await remote.savePreferences({
        'irrigationAlerts': _irrigationAlerts,
        'soilAlerts': _soilAlerts,
        'securityAlerts': _securityAlerts,
        'weatherAlerts': _weatherAlerts,
        'systemAlerts': _systemAlerts,
      });
      _feedbackMessage = 'Preferences saved';
      _isError = false;
    } on Exception {
      _feedbackMessage = 'Could not save preferences';
      _isError = true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}

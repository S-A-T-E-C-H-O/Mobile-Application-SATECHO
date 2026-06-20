import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/onboarding/domain/onboarding_repository.dart';

class OnboardingWizardController extends ChangeNotifier {
  OnboardingWizardController({required OnboardingRepository repository})
      : _repository = repository;

  final OnboardingRepository _repository;

  int _step = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Farm step fields
  String farmName = '';
  String farmLocation = '';
  String farmHectares = '';
  String cropType = '';
  List<String> availableCropTypes = [];

  // Zone step fields
  String zoneName = '';

  int get step => _step;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCropTypes() async {
    try {
      availableCropTypes = await _repository.getCropTypeNames();
      notifyListeners();
    } on Exception {
      // keep empty; page falls back to free text input
    }
  }

  void nextStep() {
    if (_step < 2) {
      _step++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_step > 0) {
      _step--;
      notifyListeners();
    }
  }

  Future<bool> complete() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.completeOnboarding({
        'farmName': farmName,
        'location': farmLocation,
        'hectares': double.tryParse(farmHectares) ?? 0,
        'cropType': cropType,
        'zoneName': zoneName.isEmpty ? 'Main Zone' : zoneName,
      });
      return true;
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

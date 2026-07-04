class OnboardingStatusModel {
  const OnboardingStatusModel(
      {required this.completed, required this.currentStep});

  final bool completed;
  final int currentStep;

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStatusModel(
      completed: json['completed'] as bool? ?? false,
      currentStep: json['currentStep'] as int? ?? 0,
    );
  }
}

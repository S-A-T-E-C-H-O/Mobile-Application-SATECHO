enum ActivityType { manualWatering, fertilizer, pestControl, observation }

extension ActivityTypeLabel on ActivityType {
  String get label {
    return switch (this) {
      ActivityType.manualWatering => 'Manual watering',
      ActivityType.fertilizer => 'Fertilizer',
      ActivityType.pestControl => 'Pest control',
      ActivityType.observation => 'Observation',
    };
  }
}

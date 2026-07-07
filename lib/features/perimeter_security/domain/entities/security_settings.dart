class SecuritySettings {
  const SecuritySettings({
    required this.id,
    required this.farmId,
    required this.motionSensitivity,
    required this.alertMode,
    required this.detectionScheduleStart,
    required this.detectionScheduleEnd,
    required this.notificationContacts,
    required this.disabledZoneIds,
  });

  final int id;
  final int farmId;
  final int motionSensitivity;
  final String alertMode;
  final String detectionScheduleStart;
  final String detectionScheduleEnd;
  final String notificationContacts;
  final Set<int> disabledZoneIds;
}

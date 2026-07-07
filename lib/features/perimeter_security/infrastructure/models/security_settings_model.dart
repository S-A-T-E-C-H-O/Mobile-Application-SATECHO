class SecuritySettingsModel {
  const SecuritySettingsModel({
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

  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) {
    return SecuritySettingsModel(
      id: json['id'] as int,
      farmId: json['farmId'] as int,
      motionSensitivity: json['motionSensitivity'] as int? ?? 70,
      alertMode: json['alertMode'] as String? ?? 'MOTION_ONLY',
      detectionScheduleStart:
          json['detectionScheduleStart'] as String? ?? '18:00',
      detectionScheduleEnd:
          json['detectionScheduleEnd'] as String? ?? '06:00',
      notificationContacts:
          json['notificationContacts'] as String? ?? '',
      disabledZoneIds: (json['disabledZoneIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
          const <int>{},
    );
  }
}

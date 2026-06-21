class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.farmName,
    required this.farmAreaLabel,
    required this.photoUrl,
    required this.notificationPreference,
    required this.units,
    required this.offlineMode,
    required this.language,
  });

  final String id;
  final String name;
  final String farmName;
  final String farmAreaLabel;
  final String photoUrl;
  final String notificationPreference;
  final String units;
  final String offlineMode;
  final String language;
}

class Device {
  const Device({
    required this.id,
    required this.plotId,
    required this.name,
    required this.status,
    this.batteryPercent,
    this.signalStrength,
    this.lastSeenAt,
  });

  final String id;
  final String plotId;
  final String name;
  final String status;
  final int? batteryPercent;
  final int? signalStrength;
  final DateTime? lastSeenAt;

  bool get isOnline => status != 'OFFLINE';
  bool get isDegraded => status == 'DEGRADED' || status == 'WARNING';
}

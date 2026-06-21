class DeviceModel {
  const DeviceModel({
    required this.id,
    required this.serialNumber,
    required this.type,
    required this.status,
    required this.online,
    required this.healthStatus,
    this.batteryPercent,
    this.signalStrength,
    this.lastSeenAt,
  });

  final int id;
  final String serialNumber;
  final String type;
  final String status;
  final bool online;
  final String healthStatus;
  final int? batteryPercent;
  final int? signalStrength;
  final DateTime? lastSeenAt;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as int,
      serialNumber: json['serialNumber'] as String,
      type: json['type'] as String? ?? 'SENSOR',
      status: json['status'] as String? ?? 'ACTIVE',
      online: json['online'] as bool? ?? false,
      healthStatus: json['healthStatus'] as String? ?? 'UNKNOWN',
      batteryPercent: json['batteryLevel'] as int?,
      signalStrength: json['signalStrength'] as int?,
      lastSeenAt: json['lastSeenAt'] != null
          ? DateTime.tryParse(json['lastSeenAt'] as String)
          : null,
    );
  }
}

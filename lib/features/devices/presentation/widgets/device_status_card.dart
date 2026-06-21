import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/presentation/widgets/app_card.dart';
import 'package:satecho_mobile/features/devices/domain/entities/device.dart';

class DeviceStatusCard extends StatelessWidget {
  const DeviceStatusCard({required this.device, super.key});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(device.status);
    final label = _statusLabel(device.status);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusBg(device.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (device.lastSeenAt != null) ...[
                      const SizedBox(width: 10),
                      Text(
                        _lastSeenLabel(device.lastSeenAt!),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (device.batteryPercent != null) ...[
                Row(
                  children: [
                    Icon(
                      _batteryIcon(device.batteryPercent!),
                      size: 18,
                      color: _batteryColor(device.batteryPercent!),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${device.batteryPercent}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _batteryColor(device.batteryPercent!),
                      ),
                    ),
                  ],
                ),
              ],
              if (device.signalStrength != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.signal_cellular_alt,
                        size: 16, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(
                      '${device.signalStrength}%',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'HEALTHY':
        return const Color(0xFF07AF73);
      case 'DEGRADED':
      case 'WARNING':
        return AppColors.warning;
      default:
        return AppColors.danger;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'HEALTHY':
        return const Color(0xFFE6F7F1);
      case 'DEGRADED':
      case 'WARNING':
        return AppColors.warningSoft;
      default:
        return AppColors.dangerSoft;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'HEALTHY':
        return 'Online';
      case 'DEGRADED':
        return 'Degraded';
      case 'WARNING':
        return 'Warning';
      default:
        return 'Offline';
    }
  }

  IconData _batteryIcon(int percent) {
    if (percent > 80) return Icons.battery_full;
    if (percent > 50) return Icons.battery_5_bar;
    if (percent > 20) return Icons.battery_3_bar;
    return Icons.battery_alert;
  }

  Color _batteryColor(int percent) {
    if (percent > 50) return AppColors.primary;
    if (percent > 20) return AppColors.warning;
    return AppColors.danger;
  }

  String _lastSeenLabel(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    return 'hace ${diff.inDays}d';
  }
}

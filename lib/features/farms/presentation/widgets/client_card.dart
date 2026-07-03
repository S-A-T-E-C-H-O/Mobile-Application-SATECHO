import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({required this.client, required this.onTap, super.key});

  final AssignedClient client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final farm = client.farm;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    farm.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                _StatusBadge(label: farm.status, alert: farm.alertCount > 0),
              ],
            ),
            const SizedBox(height: 8),
            Text(farm.ownerName,
                style: const TextStyle(fontSize: 14, color: AppColors.text)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _SoftChip(label: farm.crop),
                _SoftChip(label: farm.zoneLabel, warm: true),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                _ClientMetric(
                    icon: Icons.water_drop_outlined,
                    value: _value(farm.soilHumidity, '%'),
                    label: 'Soil'),
                _ClientMetric(
                    icon: Icons.thermostat,
                    value: _value(farm.temperature, '°C'),
                    label: 'Temp',
                    danger: farm.temperature != null && farm.temperature! > 30),
                _ClientMetric(
                    icon: Icons.bolt_outlined,
                    value: farm.ec?.toStringAsFixed(1) ?? '-',
                    label: 'EC'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _value(int? value, String unit) => value == null ? '-' : '$value$unit';
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.alert});

  final String label;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: alert ? AppColors.dangerSoft : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        alert ? '⚠ $label' : '✓ $label',
        style: TextStyle(
          color: alert ? AppColors.danger : AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({required this.label, this.warm = false});

  final String label;
  final bool warm;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: warm ? const Color(0xFFF3E9E5) : AppColors.primarySoft,
      labelStyle:
          TextStyle(color: warm ? const Color(0xFF9B5A3E) : AppColors.primary),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ClientMetric extends StatelessWidget {
  const _ClientMetric({
    required this.icon,
    required this.value,
    required this.label,
    this.danger = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon,
              color: danger ? AppColors.danger : AppColors.muted, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: danger ? AppColors.danger : AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Text(label,
              style: const TextStyle(color: AppColors.text, fontSize: 11)),
        ],
      ),
    );
  }
}

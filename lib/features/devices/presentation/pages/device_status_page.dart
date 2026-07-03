import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/devices/presentation/controllers/devices_controller.dart';
import 'package:satecho_mobile/features/devices/presentation/widgets/device_status_card.dart';

class DeviceStatusPage extends StatefulWidget {
  const DeviceStatusPage({super.key});

  @override
  State<DeviceStatusPage> createState() => _DeviceStatusPageState();
}

class _DeviceStatusPageState extends State<DeviceStatusPage> {
  late final DevicesController _controller;

  static const _filters = [
    (label: 'All', value: null),
    (label: 'Online', value: 'HEALTHY'),
    (label: 'Degraded', value: 'DEGRADED'),
    (label: 'Offline', value: 'OFFLINE'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createDevicesController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ListView(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 12,
                20,
                MediaQuery.of(context).padding.bottom + 20),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 32),
                    ),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Text(
                      'Device Status',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              if (!_controller.isLoading) ...[
                Row(
                  children: [
                    _StatChip(
                      label: 'Online',
                      count: _controller.onlineCount,
                      color: const Color(0xFF07AF73),
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      label: 'Offline',
                      count: _controller.offlineCount,
                      color: AppColors.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final selected = _controller.statusFilter == f.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        label: Text(f.label),
                        selected: selected,
                        onSelected: (_) => _controller.setFilter(f.value),
                        selectedColor: AppColors.primarySoft,
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected ? AppColors.primary : AppColors.muted,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                        side: BorderSide(
                          color:
                              selected ? AppColors.primary : AppColors.border,
                        ),
                        backgroundColor: AppColors.surface,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_controller.errorMessage != null)
                Text(
                  _controller.errorMessage!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 16),
                )
              else if (_controller.devices.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      'No devices found',
                      style: TextStyle(color: AppColors.muted, fontSize: 18),
                    ),
                  ),
                )
              else
                ..._controller.devices.map(
                  (device) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: DeviceStatusCard(device: device),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$count $label',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

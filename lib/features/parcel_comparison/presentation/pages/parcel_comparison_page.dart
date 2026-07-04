import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/parcel_comparison/presentation/controllers/parcel_comparison_controller.dart';

/// EP-012-US027: pick 2-4 parcels from any assigned client and compare
/// average moisture/EC/temperature side by side.
class ParcelComparisonPage extends StatefulWidget {
  const ParcelComparisonPage({super.key});

  @override
  State<ParcelComparisonPage> createState() => _ParcelComparisonPageState();
}

class _ParcelComparisonPageState extends State<ParcelComparisonPage> {
  late final ParcelComparisonController _controller;

  @override
  void initState() {
    super.initState();
    final deps = AppDependenciesScope.of(context);
    _controller = ParcelComparisonController(
      deps.compareParcels,
      deps.getAssignedClients,
    );
    _controller.loadClients();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare parcels')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.loadingClients) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text(
                'Select up to 4 parcels (${_controller.selectedZoneIds.length}/4)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              for (final client in _controller.clients)
                for (final zone in client.zones)
                  CheckboxListTile(
                    value: _controller.selectedZoneIds
                        .contains(int.tryParse(zone.id) ?? -1),
                    onChanged: (_) {
                      final id = int.tryParse(zone.id);
                      if (id != null) _controller.toggleZone(id);
                    },
                    title: Text('${zone.name} — ${client.farm.ownerName}'),
                    subtitle: Text(zone.areaLabel),
                  ),
              if (_controller.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(_controller.error!,
                      style: const TextStyle(color: AppColors.danger)),
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _controller.selectedZoneIds.isEmpty ||
                        _controller.loadingComparison
                    ? null
                    : _controller.compare,
                style:
                    FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: _controller.loadingComparison
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Compare'),
              ),
              const SizedBox(height: 20),
              for (final result in _controller.results)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.zoneName ?? 'Zone ${result.zoneId}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Moisture: ${result.soilMoisture?.toStringAsFixed(1) ?? '-'}%'),
                        Text('EC: ${result.electricalConductivity?.toStringAsFixed(2) ?? '-'} dS/m'),
                        Text('Temperature: ${result.soilTemperature?.toStringAsFixed(1) ?? '-'}°C'),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

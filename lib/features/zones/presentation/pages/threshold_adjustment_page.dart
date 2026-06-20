import 'package:flutter/material.dart';

import '../../../../app/di/mock_dependencies.dart';
import '../../../../app/theme/app_colors.dart';

class ThresholdAdjustmentPage extends StatefulWidget {
  const ThresholdAdjustmentPage({
    required this.zoneId,
    required this.zoneName,
    required this.cropType,
    super.key,
  });

  final String zoneId;
  final String zoneName;
  final String cropType;

  @override
  State<ThresholdAdjustmentPage> createState() =>
      _ThresholdAdjustmentPageState();
}

class _ThresholdAdjustmentPageState extends State<ThresholdAdjustmentPage> {
  final _minHumidityController = TextEditingController(text: '30');
  final _maxHumidityController = TextEditingController(text: '70');
  final _minEcController = TextEditingController(text: '0.5');
  final _maxEcController = TextEditingController(text: '3.0');
  final _minPhController = TextEditingController(text: '5.5');
  final _maxPhController = TextEditingController(text: '7.5');
  bool _isSaving = false;

  @override
  void dispose() {
    _minHumidityController.dispose();
    _maxHumidityController.dispose();
    _minEcController.dispose();
    _maxEcController.dispose();
    _minPhController.dispose();
    _maxPhController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final repo = AppDependenciesScope.of(context).zoneRepository;
      await repo.updateThresholds(widget.zoneId, {
        'minSoilMoisture':
            double.tryParse(_minHumidityController.text) ?? 30,
        'maxSoilMoisture':
            double.tryParse(_maxHumidityController.text) ?? 70,
        'minElectricalConductivity':
            double.tryParse(_minEcController.text) ?? 0.5,
        'maxElectricalConductivity':
            double.tryParse(_maxEcController.text) ?? 3.0,
        'minSoilPh': double.tryParse(_minPhController.text) ?? 5.5,
        'maxSoilPh': double.tryParse(_maxPhController.text) ?? 7.5,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thresholds updated')),
        );
        Navigator.of(context).maybePop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update thresholds')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(28, 34, 28, 112),
        children: [
          Row(
            children: [
              Material(
                color: AppColors.surface,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.chevron_left, size: 30),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thresholds',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(
                      '${widget.zoneName} · ${widget.cropType}',
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _ThresholdGroup(
            icon: Icons.water_drop_outlined,
            title: 'Soil Moisture (%)',
            color: AppColors.primary,
            minController: _minHumidityController,
            maxController: _maxHumidityController,
          ),
          const SizedBox(height: 16),
          _ThresholdGroup(
            icon: Icons.bolt_outlined,
            title: 'Electrical Conductivity (dS/m)',
            color: const Color(0xFFE5A228),
            minController: _minEcController,
            maxController: _maxEcController,
          ),
          const SizedBox(height: 16),
          _ThresholdGroup(
            icon: Icons.science_outlined,
            title: 'Soil pH',
            color: const Color(0xFF5B8C5A),
            minController: _minPhController,
            maxController: _maxPhController,
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Update thresholds'),
          ),
        ],
      ),
    );
  }
}

class _ThresholdGroup extends StatelessWidget {
  const _ThresholdGroup({
    required this.icon,
    required this.title,
    required this.color,
    required this.minController,
    required this.maxController,
  });

  final IconData icon;
  final String title;
  final Color color;
  final TextEditingController minController;
  final TextEditingController maxController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E4DF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ThresholdField(
                    label: 'Min',
                    controller: minController,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ThresholdField(
                    label: 'Max',
                    controller: maxController,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThresholdField extends StatelessWidget {
  const _ThresholdField({
    required this.label,
    required this.controller,
    required this.color,
  });

  final String label;
  final TextEditingController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFD3D7D1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(color: color),
            ),
          ),
        ),
      ],
    );
  }
}

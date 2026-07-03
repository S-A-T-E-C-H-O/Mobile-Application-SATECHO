import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  double _sensitivity = 0.7;
  bool _nightMode = true;
  bool _motionAlerts = true;
  bool _perimeterAlerts = true;
  String _alertDelay = '5 seconds';
  bool _isSaving = false;

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
              Text('Security settings',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 26),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'PIR Sensor',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.text),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Detection sensitivity'),
                          ),
                          Text(
                            '${(_sensitivity * 100).round()}%',
                            style: const TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Slider(
                        value: _sensitivity,
                        onChanged: (v) => setState(() => _sensitivity = v),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Night mode (higher sensitivity)'),
                  trailing: Switch(
                    value: _nightMode,
                    onChanged: (v) => setState(() => _nightMode = v),
                    activeColor: AppColors.primary,
                  ),
                ),
                ListTile(
                  title: const Text('Alert delay'),
                  trailing: DropdownButton<String>(
                    value: _alertDelay,
                    underline: const SizedBox.shrink(),
                    items: [
                      '0 seconds',
                      '5 seconds',
                      '10 seconds',
                      '30 seconds'
                    ]
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _alertDelay = v ?? _alertDelay),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.text),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Motion alerts'),
                  trailing: Switch(
                    value: _motionAlerts,
                    onChanged: (v) => setState(() => _motionAlerts = v),
                    activeColor: AppColors.primary,
                  ),
                ),
                ListTile(
                  title: const Text('Perimeter breach alerts'),
                  trailing: Switch(
                    value: _perimeterAlerts,
                    onChanged: (v) => setState(() => _perimeterAlerts = v),
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),
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
                : const Text('Save settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security settings saved')),
    );
  }
}

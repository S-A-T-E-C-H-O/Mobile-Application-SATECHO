import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';

class AgronomistFiltersPage extends StatefulWidget {
  const AgronomistFiltersPage({super.key});

  @override
  State<AgronomistFiltersPage> createState() => _AgronomistFiltersPageState();
}

class _AgronomistFiltersPageState extends State<AgronomistFiltersPage> {
  String zone = 'North';
  String crop = 'Corn';
  String risk = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close)),
                  const Expanded(
                    child: Text(
                      'Filters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _FilterGroup(
                      title: 'Zona',
                      selected: zone,
                      values: const ['North', 'South', 'East', 'West'],
                      onSelected: (v) => setState(() => zone = v)),
                  _FilterGroup(
                      title: 'Cultivo',
                      selected: crop,
                      values: const ['Soy', 'Corn', 'Wheat', 'Sunflower'],
                      onSelected: (v) => setState(() => crop = v)),
                  _FilterGroup(
                      title: 'Riesgo',
                      selected: risk,
                      values: const ['Low', 'Medium', 'High'],
                      onSelected: (v) => setState(() => risk = v),
                      dangerValue: 'High'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        zone = '';
                        crop = '';
                        risk = '';
                      }),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Clean'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Apply filters'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({
    required this.title,
    required this.selected,
    required this.values,
    required this.onSelected,
    this.dangerValue,
  });

  final String title;
  final String selected;
  final List<String> values;
  final ValueChanged<String> onSelected;
  final String? dangerValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 6),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, color: AppColors.text)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in values)
                ChoiceChip(
                  selected: selected == value,
                  label: Text(selected == value ? '✓ $value' : value),
                  selectedColor: value == dangerValue
                      ? AppColors.dangerSoft
                      : const Color(0xFF80A482),
                  backgroundColor: AppColors.background,
                  side: const BorderSide(color: Color(0xFFC7CEC3)),
                  labelStyle: TextStyle(
                      color: selected == value && value == dangerValue
                          ? AppColors.danger
                          : AppColors.text),
                  onSelected: (_) => onSelected(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

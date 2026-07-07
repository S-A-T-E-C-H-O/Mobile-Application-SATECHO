import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
import 'package:satecho_mobile/features/advisory/presentation/controllers/new_recommendation_controller.dart';

class NewRecommendationPage extends StatefulWidget {
  const NewRecommendationPage({super.key});

  @override
  State<NewRecommendationPage> createState() => _NewRecommendationPageState();
}

class _NewRecommendationPageState extends State<NewRecommendationPage> {
  late final NewRecommendationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AppDependenciesScope.of(context).createNewRecommendationController();
    controller.loadClients();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Row(
                    children: [
                      Material(
                        color: AppColors.surface,
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.chevron_left),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'New recommendation',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _StepHeader(step: controller.step),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                  children: [
                    if (controller.step == 0) _PlotStep(controller: controller),
                    if (controller.step == 1)
                      _ProblemStep(controller: controller),
                    if (controller.step == 2)
                      _ProposalStep(controller: controller),
                    if (controller.step == 3)
                      _PriorityStep(controller: controller),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    const labels = ['Plot', 'Problem', 'Proposal', 'Priority'];
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: Container(
                  height: 4,
                  color: i <= step ? AppColors.primary : AppColors.border,
                ),
              ),
          ],
        ),
        Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: i <= step ? AppColors.primary : AppColors.muted,
                      fontWeight: i == step ? FontWeight.w800 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _PlotStep extends StatelessWidget {
  const _PlotStep({required this.controller});

  final NewRecommendationController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.loadingClients) {
      return const AppLoadingState();
    }
    final farmerIdByZoneId = <String, int>{};
    final entries = <(String, String, String)>[];
    for (final client in controller.clients) {
      final farmerId = int.tryParse(client.farm.id);
      if (farmerId == null) continue;
      for (final zone in client.zones) {
        farmerIdByZoneId[zone.id] = farmerId;
        entries.add((
          zone.id,
          '${zone.name} — ${client.farm.ownerName}',
          '${zone.areaLabel} · Hum: ${zone.humidity}%'
        ));
      }
    }
    if (entries.isEmpty) {
      return const AppEmptyState(
        icon: Icons.people_outline,
        title: 'Sin parcelas asignadas',
        message: 'No se encontraron parcelas de clientes asignados.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select the plot', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 18),
        for (final entry in entries)
          _OptionCard(
            title: entry.$2,
            subtitle: entry.$3,
            onTap: () =>
                controller.selectZone(entry.$1, farmerIdByZoneId[entry.$1]!),
          ),
      ],
    );
  }
}

class _ProblemStep extends StatelessWidget {
  const _ProblemStep({required this.controller});

  final NewRecommendationController controller;

  @override
  Widget build(BuildContext context) {
    const problems = [
      'Water stress',
      'Pest / disease',
      'Nutritional deficiency',
      'EC out of range',
      'Other',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select the detected problem',
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 18),
        for (final problem in problems)
          _OptionCard(
              title: problem, onTap: () => controller.selectProblem(problem)),
      ],
    );
  }
}

class _ProposalStep extends StatelessWidget {
  const _ProposalStep({required this.controller});

  final NewRecommendationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Technical proposal',
            style: TextStyle(color: AppColors.muted, fontSize: 20)),
        const SizedBox(height: 24),
        _TextInput(
            label: 'Product / action',
            hint: 'Ej: Mancozeb, Riego, Urea...',
            onChanged: (v) => controller.setProposal(productValue: v)),
        _TextInput(
            label: 'Dose / quantity',
            hint: 'Ej: 2 kg/ha, 35 mm, 80 kg/ha...',
            onChanged: (v) => controller.setProposal(doseValue: v)),
        _TextInput(
            label: 'Suggested date',
            hint: 'Ej: Hoy, Mañana, 20 May...',
            onChanged: (v) => controller.setProposal(dateValue: v)),
        const SizedBox(height: 220),
        FilledButton(
          onPressed: controller.next,
          style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF80A482),
              minimumSize: const Size.fromHeight(54)),
          child: const Text('Next'),
        ),
      ],
    );
  }
}

class _PriorityStep extends StatelessWidget {
  const _PriorityStep({required this.controller});

  final NewRecommendationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommendation priority', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16),
        for (final item in const [
          ('High', 'Urgent, requires immediate action', AppColors.danger),
          ('Medium', 'Important, in the coming days', Color(0xFF9B5A3E)),
          ('Low', 'Preventative, it can wait', AppColors.primary),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => controller.selectPriority(item.$1),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: controller.priority == item.$1
                          ? item.$3
                          : AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$1,
                        style: TextStyle(
                            color: item.$3, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(item.$2,
                        style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.neutralTile,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft, child: Text('SUMMARY')),
              _SummaryLine(label: 'Plot', value: controller.zoneId),
              _SummaryLine(label: 'Problem', value: controller.problem),
              _SummaryLine(
                  label: 'Product',
                  value: controller.product.isEmpty ? '-' : controller.product),
              _SummaryLine(
                  label: 'Dose',
                  value: controller.dose.isEmpty ? '-' : controller.dose),
              _SummaryLine(
                  label: 'Date',
                  value: controller.suggestedDate.isEmpty
                      ? '-'
                      : controller.suggestedDate),
              _SummaryLine(label: 'Priority', value: controller.priority),
            ],
          ),
        ),
        const SizedBox(height: 36),
        FilledButton(
          onPressed: () async {
            await controller.send();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recommendation sent locally')));
              Navigator.of(context).maybePop();
            }
          },
          style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF80A482),
              minimumSize: const Size.fromHeight(54)),
          child: const Text('Enviar recomendación'),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.dotColor,
  });

  final String title;
  final String? subtitle;
  final Color? dotColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              if (dotColor != null) ...[
                CircleAvatar(radius: 6, backgroundColor: dotColor),
                const SizedBox(width: 18),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput(
      {required this.label, required this.hint, required this.onChanged});

  final String label;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.surface,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(label, style: const TextStyle(color: AppColors.muted))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

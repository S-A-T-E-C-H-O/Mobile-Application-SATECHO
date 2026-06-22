import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';

class FieldVisitPage extends StatefulWidget {
  const FieldVisitPage({super.key});

  @override
  State<FieldVisitPage> createState() => _FieldVisitPageState();
}

class _FieldVisitPageState extends State<FieldVisitPage> {
  late final controller =
      AppDependenciesScope.of(context).createFieldVisitController();
  final items = const [
    'Check sensors (battery, signal, calibration)',
    'Assess for the presence of pests / diseases',
    'Take soil/plant tissue samples',
    'Photograph the state of the crop',
    'Check irrigation system / drippers',
    'Record technical notes',
  ];

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
          return ListView(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 40),
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Field visit',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w800)),
                        Text('La Esperanza • 16 May 11:00'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Expanded(
                        child: Text(
                            'GPS: -31.9876° S, -64.2341° O\nDowntown area')),
                    FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF80A482)),
                        child: const Text('Browse')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: controller.completed.length / controller.total,
                      color: AppColors.primary,
                      backgroundColor: AppColors.border,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${controller.completed.length}/${controller.total}'),
                ],
              ),
              const SizedBox(height: 28),
              const Text('CHECKLIST',
                  style: TextStyle(
                      color: AppColors.muted, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => controller.toggle(i),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                              controller.completed.contains(i)
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: AppColors.primary),
                          const SizedBox(width: 14),
                          Expanded(
                              child: Text(items[i],
                                  style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              const Text('PHOTOS AND NOTES',
                  style: TextStyle(
                      color: AppColors.muted, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Expanded(
                      child: Container(
                        height: 96,
                        margin: EdgeInsets.only(right: i == 2 ? 0 : 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFC7CEC3),
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                minLines: 5,
                maxLines: 5,
                onChanged: controller.setNotes,
                decoration: InputDecoration(
                  hintText: 'Technical notes from the visit...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () async {
                  await controller.save();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visit saved locally')));
                  }
                },
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18)),
                child: Text(
                    controller.saved ? 'Saved locally' : 'Save this visit'),
              ),
            ],
          );
        },
      ),
    );
  }
}

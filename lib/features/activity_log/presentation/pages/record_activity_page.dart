import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';
import 'package:satecho_mobile/features/activity_log/presentation/controllers/activity_flow_controller.dart';
import 'package:satecho_mobile/features/activity_log/presentation/widgets/activity_step_indicator.dart';
import 'package:satecho_mobile/features/activity_log/presentation/widgets/activity_type_card.dart';
import 'activity_confirmation_page.dart';

class RecordActivityPage extends StatefulWidget {
  const RecordActivityPage({super.key});

  @override
  State<RecordActivityPage> createState() => _RecordActivityPageState();
}

class _RecordActivityPageState extends State<RecordActivityPage> {
  late final ActivityFlowController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createActivityFlowController();
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
            padding: const EdgeInsets.fromLTRB(28, 46, 28, 40),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close,
                          size: 24, color: AppColors.muted),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Record activity',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const ActivityStepIndicator(currentStep: 2),
              const SizedBox(height: 20),
              const Text(
                'What did you do?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Type of activity',
                style: TextStyle(fontSize: 14, color: AppColors.muted),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 280,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final type in ActivityType.values)
                        ActivityTypeCard(
                          type: type,
                          selected: _controller.selectedType == type,
                          onTap: () {
                            _controller.selectType(type);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ActivityConfirmationPage(
                                  controller: _controller,
                                ),
                              ),
                            );
                          },
                        ),
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

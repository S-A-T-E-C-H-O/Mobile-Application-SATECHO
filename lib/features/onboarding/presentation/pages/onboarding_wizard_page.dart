import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/onboarding/presentation/controllers/onboarding_wizard_controller.dart';

class OnboardingWizardPage extends StatefulWidget {
  const OnboardingWizardPage({required this.onCompleted, super.key});

  final VoidCallback onCompleted;

  @override
  State<OnboardingWizardPage> createState() => _OnboardingWizardPageState();
}

class _OnboardingWizardPageState extends State<OnboardingWizardPage> {
  late final OnboardingWizardController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createOnboardingWizardController();
    _controller.loadCropTypes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final ok = await _controller.complete();
    if (!mounted) return;
    if (ok) widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              children: [
                _WizardHeader(
                  step: _controller.step,
                  totalSteps: 3,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 24),
                    child: switch (_controller.step) {
                      0 => _FarmStep(controller: _controller),
                      1 => _ZoneStep(controller: _controller),
                      _ => _ReviewStep(controller: _controller),
                    },
                  ),
                ),
                _WizardNav(
                  controller: _controller,
                  onFinish: _finish,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final titles = ['Your farm', 'Zones', 'Review'];
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.eco_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text('AgroSafe Setup',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(totalSteps, (i) {
              final active = i == step;
              final done = i < step;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: done || active
                        ? AppColors.primary
                        : const Color(0xFFE0E4DF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Step ${step + 1} of $totalSteps — ${titles[step]}',
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _FarmStep extends StatelessWidget {
  const _FarmStep({required this.controller});

  final OnboardingWizardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tell us about your farm',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('We\'ll use this to set up monitoring and alerts',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.muted)),
        const SizedBox(height: 28),
        _Field(
          label: 'Farm name',
          hint: 'e.g. Fundo San José',
          onChanged: (v) => controller.farmName = v,
        ),
        const SizedBox(height: 18),
        _Field(
          label: 'Location',
          hint: 'City, Region',
          onChanged: (v) => controller.farmLocation = v,
        ),
        const SizedBox(height: 18),
        _Field(
          label: 'Total area (hectares)',
          hint: '0.00',
          keyboardType: TextInputType.number,
          onChanged: (v) => controller.farmHectares = v,
        ),
        const SizedBox(height: 18),
        if (controller.availableCropTypes.isEmpty)
          _Field(
            label: 'Main crop',
            hint: 'e.g. Corn, Soy, Wheat',
            onChanged: (v) => controller.cropType = v,
          )
        else
          _CropDropdown(controller: controller),
      ],
    );
  }
}

class _ZoneStep extends StatelessWidget {
  const _ZoneStep({required this.controller});

  final OnboardingWizardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Set up your first zone',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Zones are sectors within your farm with IoT sensors',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.muted)),
        const SizedBox(height: 28),
        _Field(
          label: 'Zone name',
          hint: 'e.g. Northern Sector',
          onChanged: (v) => controller.zoneName = v,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You can add more zones and sensors later from the dashboard.',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary.withValues(alpha: 0.9)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({required this.controller});

  final OnboardingWizardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ready to go!',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Review your setup before finishing',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.muted)),
        const SizedBox(height: 28),
        _ReviewItem(label: 'Farm name', value: controller.farmName),
        _ReviewItem(label: 'Location', value: controller.farmLocation),
        _ReviewItem(
            label: 'Area',
            value: '${controller.farmHectares} ha'),
        _ReviewItem(label: 'Crop', value: controller.cropType),
        _ReviewItem(
            label: 'First zone',
            value: controller.zoneName.isEmpty
                ? 'Main Zone'
                : controller.zoneName),
        const SizedBox(height: 24),
        if (controller.errorMessage != null)
          Text(
            controller.errorMessage!,
            style: const TextStyle(color: AppColors.danger, fontSize: 14),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.muted, fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardNav extends StatelessWidget {
  const _WizardNav(
      {required this.controller, required this.onFinish});

  final OnboardingWizardController controller;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final isLast = controller.step == 2;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
        child: Row(
          children: [
            if (controller.step > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      controller.isLoading ? null : controller.prevStep,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (controller.step > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: controller.isLoading
                    ? null
                    : (isLast ? onFinish : controller.nextStep),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isLast ? 'Start monitoring' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CropDropdown extends StatefulWidget {
  const _CropDropdown({required this.controller});
  final OnboardingWizardController controller;

  @override
  State<_CropDropdown> createState() => _CropDropdownState();
}

class _CropDropdownState extends State<_CropDropdown> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Main crop',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selected,
          hint: const Text('Select crop type'),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFD3D7D1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          items: widget.controller.availableCropTypes
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c
                          .split('_')
                          .map((w) =>
                              w[0].toUpperCase() +
                              w.substring(1).toLowerCase())
                          .join(' '),
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() => _selected = v);
            widget.controller.cropType = v ?? '';
          },
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFD3D7D1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide:
                  const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

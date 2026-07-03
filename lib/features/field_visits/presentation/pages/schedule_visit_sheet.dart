import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/field_visits/presentation/controllers/agenda_controller.dart';

class ScheduleVisitSheet extends StatefulWidget {
  const ScheduleVisitSheet({required this.controller, super.key});

  final AgendaController controller;

  @override
  State<ScheduleVisitSheet> createState() => _ScheduleVisitSheetState();
}

class _ScheduleVisitSheetState extends State<ScheduleVisitSheet> {
  final _farmIdController = TextEditingController();
  final _tagController = TextEditingController(text: 'Field Review');
  final _noteTitleController = TextEditingController();
  final _noteBodyController = TextEditingController();
  bool _urgent = false;
  DateTime _scheduledAt = DateTime.now().add(const Duration(days: 1));
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _farmIdController.dispose();
    _tagController.dispose();
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (!mounted) return;
    setState(() {
      _scheduledAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        time?.hour ?? _scheduledAt.hour,
        time?.minute ?? _scheduledAt.minute,
      );
    });
  }

  Future<void> _submit() async {
    final farmIdText = _farmIdController.text.trim();
    final farmId = int.tryParse(farmIdText);
    if (farmId == null) {
      setState(() => _errorMessage = 'Enter a valid numeric Farm ID');
      return;
    }
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    final ok = await widget.controller.scheduleVisit(
      farmId: farmId,
      scheduledAt: _scheduledAt,
      tag: _tagController.text.trim().isEmpty
          ? 'Visit'
          : _tagController.text.trim(),
      noteTitle: _noteTitleController.text.trim(),
      noteBody: _noteBodyController.text.trim(),
      urgent: _urgent,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Could not schedule visit. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPad),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE0DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Schedule visit',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            _SheetField(
              label: 'Farm ID',
              hint: 'e.g. 42',
              controller: _farmIdController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            _SheetField(
              label: 'Visit tag',
              hint: 'e.g. Soil Sampling',
              controller: _tagController,
            ),
            const SizedBox(height: 14),
            _SheetField(
              label: 'Note title',
              hint: 'Brief subject',
              controller: _noteTitleController,
            ),
            const SizedBox(height: 14),
            _SheetField(
              label: 'Notes',
              hint: 'Additional details...',
              controller: _noteBodyController,
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: const Color(0xFFD3D7D1)),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      '${_scheduledAt.year}-'
                      '${_scheduledAt.month.toString().padLeft(2, '0')}-'
                      '${_scheduledAt.day.toString().padLeft(2, '0')}  '
                      '${_scheduledAt.hour.toString().padLeft(2, '0')}:'
                      '${_scheduledAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: _urgent,
              onChanged: (v) => setState(() => _urgent = v),
              title:
                  const Text('Mark as urgent', style: TextStyle(fontSize: 14)),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!,
                  style:
                      const TextStyle(color: AppColors.danger, fontSize: 13)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving ? null : _submit,
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
                  : const Text('Schedule visit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFD3D7D1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

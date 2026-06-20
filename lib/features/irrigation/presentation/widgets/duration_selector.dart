import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class DurationSelector extends StatelessWidget {
  const DurationSelector({
    required this.selectedMinutes,
    required this.onSelected,
    super.key,
  });

  final int selectedMinutes;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [15, 30, 45]
          .map(
            (minutes) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: _DurationButton(
                  minutes: minutes,
                  selectedMinutes: selectedMinutes,
                  onSelected: onSelected,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DurationButton extends StatelessWidget {
  const _DurationButton({
    required this.minutes,
    required this.selectedMinutes,
    required this.onSelected,
  });

  final int minutes;
  final int selectedMinutes;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onSelected(minutes),
      style: OutlinedButton.styleFrom(
        backgroundColor: selectedMinutes == minutes
            ? AppColors.primarySoft
            : AppColors.neutralTile,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        '$minutes min',
        style: const TextStyle(fontSize: 18, color: AppColors.text),
      ),
    );
  }
}

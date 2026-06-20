import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';

class PlotSegmentSelector extends StatelessWidget {
  const PlotSegmentSelector({
    required this.plots,
    required this.selectedPlot,
    required this.onSelected,
    super.key,
  });

  final List<Plot> plots;
  final Plot selectedPlot;
  final ValueChanged<Plot> onSelected;

  @override
  Widget build(BuildContext context) {
    final visiblePlots = plots.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: visiblePlots
            .map(
              (plot) => Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(plot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: plot.id == selectedPlot.id
                          ? AppColors.text
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      _shortName(plot.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: plot.id == selectedPlot.id
                            ? Colors.white
                            : AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _shortName(String name) {
    if (name.startsWith('Plot 1')) return 'Plot 1';
    if (name.startsWith('Plot 2')) return 'Plot 2';
    if (name.startsWith('Lot B')) return 'Lot B';
    return name;
  }
}

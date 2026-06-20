import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';

class TrendChartCard extends StatelessWidget {
  const TrendChartCard({
    required this.title,
    required this.color,
    required this.rising,
    super.key,
  });

  final String title;
  final Color color;
  final bool rising;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 165,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, color: AppColors.text)),
            const Spacer(),
            SizedBox(
              height: 92,
              width: double.infinity,
              child: CustomPaint(
                painter: _TrendPainter(color: color, rising: rising),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('L',
                    style: TextStyle(color: AppColors.muted, fontSize: 11)),
                Text('J',
                    style: TextStyle(color: AppColors.muted, fontSize: 11)),
                Text('D',
                    style: TextStyle(color: AppColors.muted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.color, required this.rising});

  final Color color;
  final bool rising;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, rising ? size.height * .78 : size.height * .18);
    path.cubicTo(
      size.width * .3,
      rising ? size.height * .55 : size.height * .25,
      size.width * .55,
      rising ? size.height * .4 : size.height * .75,
      size.width,
      rising ? size.height * .2 : size.height * .85,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.rising != rising;
  }
}

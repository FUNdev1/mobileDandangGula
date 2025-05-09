import 'package:flutter/material.dart';
import '../../core/models/report_model.dart';
import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_text_styles.dart';
import '../text/app_text.dart';

class TotalIncomeChart extends StatelessWidget {
  final List<ChartData> data;
  final double height;
  final bool showLabels;

  const TotalIncomeChart({
    super.key,
    required this.data,
    this.height = 300,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    return Container(
      height: 319,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Total Income",
            style: AppTextStyles.contentLabel.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                // Chart with grid lines
                CustomPaint(
                  size: Size.infinite,
                  painter: _LineChartPainter(data),
                ),

                // Labels
                if (showLabels)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Y-axis values (right aligned)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              '200',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              '150',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              '100',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              '50',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              '0',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),

                        // X-axis labels
                        Container(
                          height: 30,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: data.map((point) {
                              return AppText(
                                point.label,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartData> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width - 30;
    final height = size.height - 24; // Reserve space for X-axis labels

    // Draw grid lines
    _drawGridLines(canvas, width, height);

    // Draw line
    _drawLine(canvas, width, height);

    // Draw points
    _drawPoints(canvas, width, height);
  }

  void _drawGridLines(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = const Color(0xFFEAEEF2)
      ..strokeWidth = 1;

    // Draw horizontal grid lines (5 evenly spaced)
    final step = height / 4;
    for (int i = 0; i <= 4; i++) {
      final y = height - (i * step);
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    }
  }

  void _drawLine(Canvas canvas, double width, double height) {
    // Green line paint
    final paint = Paint()
      ..color = const Color(0xFF88DE7B)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Find max value for scaling
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    // Calculate point positions
    final pointWidth = width / (data.length - 1);

    // Start at first point
    const startX = 0.0;
    final startY = height - (data[0].value / maxValue * height);
    path.moveTo(startX, startY);

    // Draw line segments
    for (int i = 1; i < data.length; i++) {
      final x = i * pointWidth;
      final y = height - (data[i].value / maxValue * height);
      path.lineTo(x, y);
    }

    // Draw the line
    canvas.drawPath(path, paint);
  }

  void _drawPoints(Canvas canvas, double width, double height) {
    // White fill with green stroke for points
    final fillPaint = Paint()
      ..color = const Color(0xFFFBFCFE)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF88DE7B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Find max value for scaling
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    // Calculate point positions and draw points
    final pointWidth = width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * pointWidth;
      final y = height - (data[i].value / maxValue * height);

      // Draw white-filled circle with green stroke
      canvas.drawCircle(Offset(x, y), 5, fillPaint);
      canvas.drawCircle(Offset(x, y), 5, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

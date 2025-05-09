import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/models/stock_model.dart';
import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_text_styles.dart';

class StockUsageChart extends StatelessWidget {
  final List<StockUsage> data;
  final double height;
  final bool showLegend;
  final bool isDoughnut;

  const StockUsageChart({
    super.key,
    required this.data,
    this.height = 300,
    this.showLegend = true,
    this.isDoughnut = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      height: height,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _PieChartPainter(
                data: data,
                isDoughnut: isDoughnut,
              ),
              child: Container(),
            ),
          ),
          if (showLegend)
            Container(
              height: 80,
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: data.map((item) {
                  return _buildLegendItem(
                    AppColors.getColorFromId(item.groupId),
                    item.groupName,
                    item.percentage,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, double percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label (${percentage.toStringAsFixed(1)}%)',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<StockUsage> data;
  final bool isDoughnut;

  _PieChartPainter({
    required this.data,
    this.isDoughnut = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final holeRadius = isDoughnut ? radius * 0.6 : 0;

    double startAngle = -math.pi / 2; // Start from top

    for (final item in data) {
      final sweepAngle = 2 * math.pi * (item.percentage / 100);

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.getColorFromId(item.groupId);

      // Draw pie slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw hole for doughnut chart
    if (isDoughnut) {
      canvas.drawCircle(
        center,
        holeRadius.toDouble(),
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

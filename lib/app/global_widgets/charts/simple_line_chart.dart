import 'package:flutter/material.dart';
import '../../core/models/report_model.dart';
import '../../core/utils/theme/app_colors.dart';

class SimpleLineChart extends StatelessWidget {
  final List<ChartData> data;

  const SimpleLineChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // This is a simplified implementation
    // You would use a chart library for a real implementation

    if (data.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return CustomPaint(
      size: Size.infinite,
      painter: _LineChartPainter(data),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartData> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Find min and max values for normalization
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // Calculate x and y positions
    final pointWidth = size.width / (data.length - 1);

    // Draw the line
    path.moveTo(0, size.height - (data[0].value / maxValue * size.height));

    for (int i = 1; i < data.length; i++) {
      path.lineTo(
        i * pointWidth,
        size.height - (data[i].value / maxValue * size.height),
      );
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      canvas.drawCircle(
        Offset(
          i * pointWidth,
          size.height - (data[i].value / maxValue * size.height),
        ),
        4,
        fillPaint,
      );

      canvas.drawCircle(
        Offset(
          i * pointWidth,
          size.height - (data[i].value / maxValue * size.height),
        ),
        4,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

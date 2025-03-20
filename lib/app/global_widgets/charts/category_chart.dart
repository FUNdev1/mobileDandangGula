import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../data/models/category_sales_model.dart';

class CategorySalesCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<CategorySales> data;
  final double width;
  final double height;

  const CategorySalesCard({
    Key? key,
    required this.title,
    this.subtitle = 'Hari ini',
    required this.data,
    this.width = 311,
    this.height = 410,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 18 / 14,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.04,
                  height: 18 / 14,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Donut chart (pie chart with center cut out)
          Expanded(
            child: Center(
              child: SizedBox(
                width: 206,
                height: 206,
                child: CustomPaint(
                  painter: DonutChartPainter(data),
                ),
              ),
            ),
          ),

          // Legend
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: data.map((item) => _buildLegendItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(CategorySales category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: _parseColor(category.color),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          category.name,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 18 / 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class DonutChartPainter extends CustomPainter {
  final List<CategorySales> data;

  DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.45; // Size of inner circle cutout

    double startAngle = -90 * (3.14159 / 180); // Start from top, convert to radians

    // Draw segments
    for (var segment in data) {
      final sweepAngle = (segment.percentage / 100) * 2 * 3.14159; // Convert to radians
      final paint = Paint()
        ..color = _parseColor(segment.color)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw inner white circle to create donut effect
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Color _parseColor(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

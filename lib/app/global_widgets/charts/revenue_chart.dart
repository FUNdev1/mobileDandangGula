import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/chart_data_model.dart';

class RevenueChart extends StatelessWidget {
  final List<ChartData> data;

  const RevenueChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // This is a simplified implementation
    // You would use a chart library like fl_chart or syncfusion_flutter_charts
    // for a real implementation
    
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: data.map((point) {
              // Normalize height based on max value
              final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
              final height = (point.value / maxValue) * 150;
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 30,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    point.label,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}


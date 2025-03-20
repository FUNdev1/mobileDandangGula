import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/chart_data_model.dart';
import '../charts/simple_line_chart.dart';
import '../layout/app_card.dart';
import '../layout/app_layout.dart';
import '../text/app_text.dart';

class BranchPerformanceCard extends StatelessWidget {
  final String title;
  final String branchName;
  final List<ChartData> data;
  final VoidCallback onViewDetails;

  const BranchPerformanceCard({
    super.key,
    required this.title,
    required this.branchName,
    required this.data,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
  return AppCard(
      title: title,
      action: TextButton(
        onPressed: onViewDetails,
        child: Row(
          children: [
            AppText(
              'Detail',
              style: TextStyle(color: AppColors.primary),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            branchName,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: SimpleLineChart(data: data),
          ),
        ],
      ),
    );
  }
}

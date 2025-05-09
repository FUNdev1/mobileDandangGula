import 'package:flutter/material.dart';
import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_dimensions.dart';
import '../../core/utils/theme/app_text_styles.dart';
import '../../core/models/branch_model.dart';
import '../layout/app_card.dart';
import '../text/app_text.dart';

class BranchIncomeCard extends StatelessWidget {
  final Branch branch;
  final double income;
  final double percentChange;
  final double cogs;
  final double netProfit;
  final VoidCallback onTap;

  const BranchIncomeCard({
    super.key,
    required this.branch,
    required this.income,
    required this.percentChange,
    required this.cogs,
    required this.netProfit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.store,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing8),
                Expanded(
                  child: AppText(
                    branch.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            AppText(
              'Total Income',
              style: AppTextStyles.bodySmall,
            ),
            AppText(
              'Rp ${income.toStringAsFixed(0)}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                AppText(
                  'vs hari sebelumnya',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(width: AppDimensions.spacing4),
                Icon(
                  percentChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: percentChange >= 0 ? AppColors.success : AppColors.error,
                  size: 12,
                ),
                AppText(
                  '${percentChange.abs().toStringAsFixed(2)}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: percentChange >= 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'COGS',
                        style: AppTextStyles.bodySmall,
                      ),
                      AppText(
                        'Rp ${cogs.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Laba Kotor',
                        style: AppTextStyles.bodySmall,
                      ),
                      AppText(
                        'Rp ${netProfit.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:dandang_gula/app/modules/common/dashboard/controllers/pusat_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_styles.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/models/branch_model.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/dashboard_controller.dart';

class TotalIncomeCard extends StatelessWidget {
  final PusatDashboardController controller;

  const TotalIncomeCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 258,
      child: Row(
        children: [
          // Card untuk total income
          Card(
            color: AppColors.white,
            margin: EdgeInsets.zero,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Obx(() {
                final dashboardSummary = controller.dashboardRepository.dashboardSummary.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Total Income',
                      style: AppTextStyles.cardLabel.copyWith(fontSize: 16),
                    ),
                    AppText(
                      'Semua Cabang',
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 10,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppText(
                      'Total',
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    AppText(
                      CurrencyFormatter.formatRupiah(dashboardSummary.totalIncome),
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 18,
                        color: AppColors.darkGreen80,
                      ),
                    ),
                    _buildGrowthIndicator(dashboardSummary.percentChange),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 1,
                      width: 174,
                      color: AppColors.divider,
                    ),
                    // Net Profit
                    AppText(
                      'Net Profit',
                      style: AppTextStyles.cardLabel.copyWith(fontSize: 16),
                    ),
                    AppText(
                      'Total Income - Expenses',
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 10,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppText(
                      CurrencyFormatter.formatRupiah(dashboardSummary.netProfit),
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 18,
                        color: AppColors.darkGreen80,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          // Cards untuk cabang-cabang
          Expanded(
            child: _buildBranchCards(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthIndicator(double percentChange) {
    final isNegative = percentChange.isNegative;

    return Row(
      children: [
        AppText(
          'vs hari sebelumnya',
          style: AppTextStyles.cardLabel.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.darkGrey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SvgPicture.asset(
          isNegative ? AppIcons.caretDown : AppIcons.caretUp,
          height: 16,
          colorFilter: ColorFilter.mode(
            isNegative ? AppColors.redCaretDown : AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 2),
        AppText(
          '${percentChange.abs().toStringAsFixed(2)}%',
          style: AppTextStyles.cardLabel.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isNegative ? AppColors.redCaretDown : AppColors.primary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBranchCards() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        final branches = controller.branchRepository.branches;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: branches.asMap().entries.map((entry) {
              final index = entry.key;
              final branch = entry.value;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBranchCard(branch),
                  // Add divider between branch cards except for the last one
                  if (index < branches.length - 1)
                    Container(
                      width: 1,
                      height: 210,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildBranchCard(Branch branch) {
    return SizedBox(
      width: 261,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branch icon and name
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      AppIcons.appIcon,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      branch.name,
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Income
              AppText(
                'Total Income',
                style: AppTextStyles.cardLabel.copyWith(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppText(
                CurrencyFormatter.formatRupiah(99),
                style: AppTextStyles.cardLabel.copyWith(
                  fontSize: 18,
                  color: AppColors.darkGreen80,
                ),
              ),
              _buildGrowthIndicator(99),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                height: 1,
                color: AppColors.divider,
              ),

              // COGS and Laba Kotor
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'COGS',
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          CurrencyFormatter.formatRupiah(99),
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          CurrencyFormatter.formatRupiah(99),
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

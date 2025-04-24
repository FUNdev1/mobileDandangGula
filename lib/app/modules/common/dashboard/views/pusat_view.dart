import 'package:dandang_gula/app/global_widgets/charts/sales_performance_chart.dart';
import 'package:dandang_gula/app/global_widgets/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../data/models/branch_model.dart';
import '../../../../global_widgets/buttons/icon_button.dart';
import '../../../../global_widgets/charts/total_income_chart.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/pusat_dashboard_controller.dart'; // Import controller baru
import '../widgets/filter/period_filter.dart';
import '../widgets/revenue_expense_chart_card.dart';
import '../widgets/total_income_card.dart';

class PusatDashboardView extends StatelessWidget {
  // Ubah tipe controller menjadi PusatDashboardController
  final controller = DashboardController.to as PusatDashboardController;

  PusatDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          PeriodFilter(
            controller: controller.periodFilterController,
            onPeriodChanged: (periodId) {
              controller.onPeriodFilterChanged(periodId);
            },
          ),
          const SizedBox(height: AppDimensions.spacing10),

          // Total Income Card
          TotalIncomeCard(controller: controller),
          const SizedBox(height: 24),

          // Total Income Chart
          Obx(() {
            return TotalIncomeChart(
              data: controller.dashboardRepository.incomeChartData.value,
            );
          }),
          const SizedBox(height: 24),

          // Revenue vs Expense Chart Card
          RevenueExpenseChartCard(controller: controller),
          const SizedBox(height: 24),

          // Sales Performance Charts
          _buildSalesPerformanceCharts(context),
        ],
      ),
    );
  }

  Widget _buildSalesPerformanceCharts(BuildContext context) {
    return Obx(() {
      final branches = controller.branchRepository.branches;

      if (branches.isEmpty) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: AppText(
              'Data cabang belum tersedia',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            ),
          ),
        );
      }

      // Menggunakan Wrap untuk layout yang fleksibel
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1, // 2 columns on large screens, 1 on small
          childAspectRatio: 380 / 382, // Maintain aspect ratio
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: branches.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Prevent grid from scrolling
        itemBuilder: (context, index) {
          final branch = branches[index];
          // Gunakan data dari controller pusat
          final branchData = controller.allBranchSales.where((item) => item.label == branch.name).toList();
          return BranchSalesPerformanceWidget(
            branch: branch,
            data: branchData,
          );
        },
      );
    });
  }
}

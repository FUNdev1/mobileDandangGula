import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import for number formatting

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../data/models/branch_model.dart';
import '../../../../data/models/revenue_expense_data.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/dashboard_controller.dart';

class RevenueExpenseChartCard extends StatelessWidget {
  final DashboardController controller;

  const RevenueExpenseChartCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 345,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch selector (left side)
          _buildBranchSelector(),
          const SizedBox(width: 10),
          // Revenue vs Expense chart (right side)
          Expanded(
            child: Obx(() {
              final branchRepo = controller.branchRepository;
              final selectedBranchId = controller.selectedBranchId.value;
              final selectedBranch = branchRepo.branches.isNotEmpty ? branchRepo.getBranchById(selectedBranchId) : null;


              return RevenueVsExpenseChart(
                data: controller.dashboardRepository.revenueExpenseData.value,
                branchName: selectedBranch?.name ?? 'Semua Cabang',
                height: 243,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSelector() {
    return SizedBox(
      width: 274,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Cabang" label
          const Text(
            'Cabang',
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.04,
              color: Color(0xFFA9AEB3),
            ),
          ),
          const SizedBox(height: 10),

          // Branch selector items
          Obx(() {
            final branches = controller.branchRepository.branches;
            final selectedBranchId = controller.selectedBranchId.value;

            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: branches.map((branch) {
                    final isSelected = branch.id == selectedBranchId;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: _buildBranchSelectItem(
                        branch: branch,
                        isSelected: isSelected,
                        onTap: () => controller.selectBranch(branch.id),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBranchSelectItem({
    required Branch branch,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: isSelected ? const Color(0xFF88DE7B) : const Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Selection indicator (circle)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF88DE7B) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFFE1E1E1),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: Color(0xFF88DE7B),
                          spreadRadius: 1,
                          blurRadius: 0,
                        )
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 8),

            // Branch icon (placeholder)
            Image.asset(
              AppIcons.appIcon,
              height: 35,
              width: 35,
            ),

            const SizedBox(width: 8),

            // Branch name
            Expanded(
              child: Text(
                branch.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.25, // line-height: 15px
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RevenueVsExpenseChart extends StatelessWidget {
  final List<RevenueExpenseData> data;
  final String branchName;
  final double height;

  const RevenueVsExpenseChart({
    super.key,
    required this.data,
    required this.branchName,
    this.height = 350,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,#", "en_US"); // Define the number format

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and branch name row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              'Revenue Vs Expense',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            AppText(
              branchName,
              style: AppTextStyles.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Chart
        SizedBox(
          height: height, // Adjust for padding and legend
          child: data.isEmpty
              ? Center(
                  child: AppText(
                    'No data available',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                  ),
                )
              : _buildChart(currencyFormat),
        ),

        // Legend
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFF136C3A), 'Revenue'),
            const SizedBox(width: 24),
            _buildLegendItem(const Color(0xFFE7B776), 'Expense'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 6),
        AppText(
          label,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(NumberFormat currencyFormat) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chart content
            Expanded(
              child: _buildGridAndBars(constraints, currencyFormat),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridAndBars(BoxConstraints constraints, NumberFormat currencyFormat) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    // Calculate grid dimensions
    final double barSpacing = constraints.maxWidth / data.length;

    // Calculate chart height (leave space for x-axis labels)
    final double chartHeight = constraints.maxHeight - 20;

    return Stack(
      children: [
        // Grid lines - pastikan grid dimulai dari atas dan berakhir tepat di atas labels
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: chartHeight,
          child: _buildGridLines(BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
            minHeight: chartHeight,
            maxHeight: chartHeight,
          )),
        ),

        // Bars - pastikan mereka juga dimulai dari atas area yang sama
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: chartHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(data.length, (index) {
              final item = data[index];
              // Find max value for scaling
              final maxValue = data.map((e) => e.revenue > e.expense ? e.revenue : e.expense).reduce((a, b) => a > b ? a : b);

              // Calculate bar heights - relative to chartHeight
              final double revenueHeight = (item.revenue / maxValue) * chartHeight;
              final double expenseHeight = (item.expense / maxValue) * chartHeight;

              return SizedBox(
                width: barSpacing,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Revenue bar
                        _buildBar(
                          height: revenueHeight,
                          color: const Color(0xFF136C3A),
                          value: item.revenue,
                          maxHeight: chartHeight,
                        ),
                        const SizedBox(width: 4),
                        // Expense bar
                        _buildBar(
                          height: expenseHeight,
                          color: const Color(0xFFE7B776),
                          value: item.expense,
                          maxHeight: chartHeight,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // X-axis Labels - positioned at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(data.length, (index) {
              final item = data[index];
              return SizedBox(
                width: barSpacing,
                child: Center(
                  child: AppText(
                    DateFormatter.formatDate(item.date, pattern: "MMM d"),
                    style: const TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 10.5,
                      color: Color(0xFFA9AEB3),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBar({
    required double height,
    required Color color,
    required double value,
    required double maxHeight,
  }) {
    // Ensure bar height stays within bounds
    final double safeHeight = height.isNaN || height.isInfinite ? 0 : height;
    final double displayHeight = safeHeight < 10 && safeHeight > 0 ? 10.0 : safeHeight;

    // Limit maximum bar width based on available space
    const double barWidth = 32;

    return Container(
      width: barWidth,
      height: displayHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.topCenter,
      child: AppText(
        CurrencyFormatter.formatToShortK(value),
        style: const TextStyle(
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400,
          fontSize: 10.5,
          letterSpacing: -0.04,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGridLines(BoxConstraints constraints) {
    return Stack(
      // Ubah dari Column ke Stack
      children: List.generate(5, (index) {
        // Divide height into 5 equal parts
        final lineY = index * (constraints.maxHeight - 32) / 4;
        return Positioned(
          top: lineY,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: const Color(0xFFEAEEF2),
          ),
        );
      }),
    );
  }
}

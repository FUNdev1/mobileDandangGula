import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_styles.dart';
import '../../../dashboard/widgets/filter/period_filter.dart';
import '../../controllers/stock_management_controller.dart';

class StockManagementFilter extends StatelessWidget {
  final StockManagementController controller;
  final List<Widget>? actionButton;

  const StockManagementFilter({
    super.key,
    required this.controller,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Period filter component (reused from dashboard)
          PeriodFilter(
            controller: Get.find(),
            onPeriodChanged: controller.onPeriodChanged,
          ),

          const SizedBox(width: 24),

          // Category dropdown
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFB9B9B9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Obx(() => DropdownButton<String>(
                  value: controller.selectedCategoryFilter.value,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFA8A8A8)),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.onCategoryFilterChanged(newValue);
                    }
                  },
                  items: <String>['Semua Group', 'Bumbu', 'Protein', 'Sayuran', 'Minuman', 'Lainnya'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
          ),

          const SizedBox(width: 10),

          // Search field
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFB9B9B9)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Cari Bahan',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFA8A8A8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Color(0xFFA8A8A8)),
                ],
              ),
            ),
          ),

          // Action buttons (passed from parent)
          if (actionButton != null) ...actionButton!,
        ],
      ),
    );
  }
}

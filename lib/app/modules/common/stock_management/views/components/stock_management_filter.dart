import 'package:dandang_gula/app/core/utils.dart';
import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:dandang_gula/app/modules/common/stock_management/views/ingredient_group/ingredient_group_view.dart';
import 'package:dandang_gula/app/modules/common/stock_management/views/stock_opname/stock_opname_view.dart';
import 'package:dandang_gula/app/modules/common/stock_management/views/stock_purchase/stock_purchase_view.dart';
import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../global_widgets/alert/app_snackbar.dart';
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
      padding: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Period filter component - biarkan width disesuaikan
          Expanded(
            flex: 1,
            child: PeriodFilter(
              controller: Get.find(),
              onPeriodChanged: controller.onPeriodChanged,
            ),
          ),

          const SizedBox(width: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                onTap: () => Get.to(() => IngredientGroupView()),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                    height: 40,
                    // width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        AppText(
                          "Group Bahan",
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          AppIcons.arrowDownRight,
                          height: 16,
                        ),
                      ],
                    )),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // // Stok Opname button
          _buildFilterButton(
            icon: AppIcons.bottlesContainer,
            label: 'Stok Opname',
            onTap: () async {
              final res = await Get.to(() => StockOpnameView());
              if (res == true) controller.fetchData();
            },
          ),

          const SizedBox(width: 12),

          // // Pembelian Stok button
          _buildFilterButton(
            icon: AppIcons.shoppingCatalog,
            label: 'Pembelian Stok',
            onTap: () async {
              final res = await Get.to(() => StockPurchaseView());
              if (res == true) controller.fetchData();
            },
          ),

          const SizedBox(width: 12),

          // // Buat Stok Baru button (hijau) - diambil dari actionButton
          if (actionButton != null) ...actionButton!
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            // Removed Expanded here
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                SvgPicture.asset(icon, height: 18, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

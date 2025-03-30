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

          // Group Bahan dropdown
          Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedCategoryFilter.value,
                    isDense: true,
                    hint: const Text('Group Bahan'),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.onCategoryFilterChanged(newValue);
                      }
                    },
                    items: <String>['Semua Group', 'Bumbu', 'Protein', 'Sayuran', 'Minuman', 'Lainnya'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),
                )),
          ),

          const SizedBox(width: 12),

          // // Stok Opname button
          _buildFilterButton(
            icon: Icons.list_alt,
            label: 'Stok Opname',
            onTap: () {
              // Tambahkan fungsi saat tombol ditekan
            },
          ),

          const SizedBox(width: 12),

          // // Pembelian Stok button
          _buildFilterButton(
            icon: Icons.shopping_cart,
            label: 'Pembelian Stok',
            onTap: () {
              // Tambahkan fungsi saat tombol ditekan
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
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Expanded(
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/layout/tab_container.dart';
import '../controllers/stock_management_controller.dart';
import 'components/stock_management_filter.dart';
import 'components/inventory_table.dart';
import 'components/low_stock_items.dart';

class StockManagementView extends GetView<StockManagementController> {
  const StockManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final refreshKey = args['refreshKey'] ?? 0;

    return AppLayout(
      key: ValueKey('stock_management_$refreshKey'),
      content: _buildContent(context),
      onRefresh: () => controller.refreshData(),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Dapatkan ukuran layar
    final screenSize = MediaQuery.of(context).size;
    final tableHeight = screenSize.height * 0.65; // 65% dari tinggi layar

    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Inventory Filter Bar
          StockManagementFilter(
            controller: controller,
            actionButton: [
              AppButton(
                label: "Buat Stok Baru",
                prefixSvgPath: AppIcons.add,
                variant: ButtonVariant.primary,
                width: 163,
                height: 40,
                onPressed: () => controller.openAddStockModal(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Low Stock Items Horizontal Scroll
          Obx(() {
            return controller.lowStockItems.isNotEmpty ? LowStockItems(items: controller.lowStockItems) : const SizedBox.shrink();
          }),
          const SizedBox(height: 16),

          // Tabs and Table
          Container(
            clipBehavior: Clip.antiAlias,
            height: tableHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab Header
                  Row(
                    children: [
                      _buildTabHeader('Bahan Dasar', 0),
                      const SizedBox(width: 24),
                      _buildTabHeader('Bahan Setengah Jadi', 1),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tab Content dengan Expanded
// Di dalam _buildContent, ganti bagian tab content:
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: KeyedSubtree(
                        key: ValueKey<int>(controller.selectedTab.value),
                        child: controller.selectedTab.value == 0
                            ? InventoryTable(
                                items: controller.filteredInventoryItems,
                                isLoading: controller.isLoading.value,
                                controller: controller,
                              )
                            : InventoryTable(
                                items: controller.filteredSemiFinishedItems,
                                isLoading: controller.isLoading.value,
                                controller: controller,
                                isSemiFinished: true,
                              ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader(String title, int index) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return InkWell(
        onTap: () => controller.onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    });
  }
}

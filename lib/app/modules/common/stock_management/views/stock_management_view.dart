import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../controllers/stock_management_controller.dart';
import 'components/inventory_filter.dart';
import 'components/low_stock_items.dart';

class StockManagementView extends GetView<StockManagementController> {
  const StockManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: _buildContent(),
      onRefresh: () => controller.refreshData(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inventory Filter Bar
          // Expanded(
          //   child: StockManagementFilter(
          //     controller: controller,
          //     actionButton: [
          //       const Spacer(),
          //       AppButton(
          //         label: "Buat Stok Baru",
          //         prefixSvgPath: AppIcons.add,
          //         variant: ButtonVariant.primary,
          //         onPressed: () => controller.openAddStockModal(),
          //       )
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 16),

          // Low Stock Items Horizontal Scroll
          Obx(() => controller.lowStockItems.isNotEmpty ? LowStockItems(items: controller.lowStockItems) : const SizedBox.shrink()),
          const SizedBox(height: 16),

          // // Stock Tabs and Table
          // Expanded(
          //   child: StockTabs(
          //     tabs: [
          //       TabItem(
          //         title: 'Bahan Dasar',
          //         content: Obx(() => InventoryTable(
          //               items: controller.filteredInventoryItems,
          //               isLoading: controller.isLoading.value,
          //               onSort: controller.sortItems,
          //               onAction: controller.showItemActionMenu,
          //             )),
          //       ),
          //       TabItem(
          //         title: 'Bahan Setengah Jadi',
          //         content: Obx(() => InventoryTable(
          //               items: controller.filteredSemiFinishedItems,
          //               isLoading: controller.isLoading.value,
          //               onSort: controller.sortItems,
          //               onAction: controller.showItemActionMenu,
          //             )),
          //       ),
          //     ],
          //     onTabChanged: controller.onTabChanged,
          //   ),
          // ),
        ],
      ),
    );
  }
}

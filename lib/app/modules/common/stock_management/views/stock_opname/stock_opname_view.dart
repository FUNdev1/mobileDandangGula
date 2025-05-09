import 'package:dandang_gula/app/global_widgets/buttons/app_button.dart';
import 'package:dandang_gula/app/modules/common/stock_management/views/stock_opname/stock_opname_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../../global_widgets/input/app_text_field.dart';
import '../../controllers/stock_management_controller.dart';

class StockOpnameView extends StatelessWidget {
  final StockManagementController controller = Get.find<StockManagementController>();
  final RxString selectedCategory = RxString('all');
  final RxString searchQuery = RxString('');
  final Map<String, TextEditingController> stockControllers = {};
  final Map<String, RxString> differenceValues = {};

  StockOpnameView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load initial data
    controller.fetchData();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Stok Opname',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.close,
            width: 20,
            height: 20,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppButton(
              label: 'Simpan Perubahan',
              width: 157,
              height: 32,
              onPressed: () => _navigateToPreview(),
              variant: ButtonVariant.secondary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          _buildSearchBar(),
          Expanded(
            child: Obx(() => _buildInventoryItemsList()),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 62,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        // Get categories from controller
        final categories = controller.categories;
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryTab('Semua', 'all', selectedCategory.value == 'all', '${controller.inventoryItems.length}'),
            ...categories.map((category) {
              return _buildCategoryTab(
                category['group_name'] ?? 'Unknown',
                category['id'] ?? 'unknown',
                selectedCategory.value == category['id'],
                '',
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryTab(String title, String category, bool isSelected, String itemCount) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          selectedCategory.value = category;
          _filterItemsByCategory(category);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B9851) : null,
            borderRadius: BorderRadius.circular(54),
            border: isSelected ? Border.all(color: Color(0xFF136C3A)) : null,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Color(0xFFE9FBF1) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (itemCount.isNotEmpty)
                Text(
                  ' ($itemCount items)',
                  style: TextStyle(
                    color: isSelected ? Colors.white.withOpacity(0.52) : Color(0xFF3C3C4399).withOpacity(0.60),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: AppTextField(
              controller: controller.searchTextController,
              appTextFieldEnum: AppTextFieldEnum.field,
              suffixIcon: AppIcons.search,
              hint: "Cari Bahan",
              onFocusChanged: (val) {
                if (val.trim().isNotEmpty) {
                  searchQuery.value = val.trim(); // Update searchQuery
                  _filterItemsBySearch(searchQuery.value);
                }
              },
            ),
          ),

          const SizedBox(width: 12),

          // Cari Button
          AppButton(
            label: 'Cari',
            width: 54,
            variant: ButtonVariant.outline,
            outlineBorderColor: const Color(0xFF88DE7B),
            onPressed: () {
              if (controller.searchTextController.text.trim().isNotEmpty) {
                searchQuery.value = controller.searchTextController.text.trim(); // Update searchQuery
                _filterItemsBySearch(searchQuery.value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItemsList() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(),
            const Divider(),
            // Group items by category
            ...controller.groupItemsByCategory().entries.map((entry) {
              final categoryName = entry.key;
              final items = entry.value;

              return _buildCategorySection(
                  categoryName,
                  items.map((item) {
                    final itemId = item.id ?? '';
                    if (!stockControllers.containsKey(itemId)) {
                      stockControllers[itemId] = TextEditingController();
                      differenceValues[itemId] = RxString('0');
                    }

                    return _buildItemRow(
                      item.id ?? '',
                      item.name ?? '',
                      item.unitName ?? '',
                      (item.stock ?? 0).toStringAsFixed(0).toString(),
                      stockControllers[itemId]!,
                      differenceValues[itemId]!,
                    );
                  }).toList());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Nama Bahan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Satuan Kemasan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Stok Saat Ini',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Stok Fisik',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Selisih',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
    if (items.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in items) ...[
          item,
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildItemRow(
    String id,
    String? name,
    String? unit,
    String currentStock,
    TextEditingController stockController,
    RxString differenceValue,
  ) {
    return Container(
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFFBFCFE),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(name ?? "-"),
          ),
          Expanded(
            child: Text(unit ?? "-"),
          ),
          Expanded(
            flex: 2,
            child: Text(currentStock),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: AppTextField(
                controller: stockController,
                hint: 'Masukkan jumlah stok...',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onFocusChanged: (value) {
                  // Calculate difference
                  if (value.isNotEmpty) {
                    final physical = int.tryParse(value) ?? 0;
                    final current = int.tryParse(currentStock.replaceAll(',', '')) ?? 0;
                    differenceValue.value = (physical - current).toString(); // Adjusted calculation
                  } else {
                    differenceValue.value = '0';
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Obx(() => Text(differenceValue.value)),
          ),
        ],
      ),
    );
  }

  void _filterItemsByCategory(String category) {
    controller.filterItemsByCategory(category);
  }

  void _filterItemsBySearch(String query) {
    controller.filterItemsBySearch(query);
  }

  void _navigateToPreview() {
    final stockData = <Map<String, dynamic>>[];

    // Collect data from all items with filled physical stock
    for (var item in controller.inventoryItems) {
      final itemId = item.id ?? '';

      if (stockControllers.containsKey(itemId) && stockControllers[itemId]!.text.isNotEmpty) {
        final physicalStock = int.tryParse(stockControllers[itemId]!.text) ?? 0;
        final currentStock = item.stock;
        final difference = physicalStock - (currentStock ?? 0).toInt();

        stockData.add({
          'id': itemId,
          'name': item.name,
          'unit': item.unitName,
          'currentStock': currentStock,
          'physicalStock': physicalStock,
          'difference': difference,
          'category': item.category ?? _getCategoryNameById(item.categoryId),
        });
      }
    }

    if (stockData.isEmpty) {
      AppSnackBar.error(message: 'Mohon isi stok fisik minimal satu bahan');
      return;
    }

    // Navigate to preview
    Get.to(() => StockOpnamePreviewView(stockData: stockData));
  }

  String _getCategoryNameById(String? categoryId) {
    if (categoryId == null) return 'Uncategorized';

    for (var category in controller.categories) {
      if (category['id'] == categoryId) {
        return category['group_name'] ?? 'Uncategorized';
      }
    }

    return 'Uncategorized';
  }
}

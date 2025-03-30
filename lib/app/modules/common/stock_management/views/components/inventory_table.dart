import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/stock_management_controller.dart';
import '../../data/models/inventory_item_model.dart';

class InventoryTable extends StatelessWidget {
  final List<InventoryItem> items;
  final bool isLoading;
  final StockManagementController controller;
  final bool isSemiFinished;

  const InventoryTable({
    super.key,
    required this.items,
    this.isLoading = false,
    required this.controller,
    this.isSemiFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Gunakan SingleChildScrollView untuk membuat seluruh konten scrollable
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          _buildFilterBar(),

          // Table header
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: _buildTableHeader(),
          ),

          // Table Content - tanpa Expanded karena dalam SingleChildScrollView
          items.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  // Disable scrolling untuk ListView bersarang
                  physics: const NeverScrollableScrollPhysics(),
                  // Tetapkan tinggi yang sesuai berdasarkan jumlah item
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildTableRow(item);
                  },
                ),

          // Pagination
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Dropdown category
          Obx(() => Container(
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      value: controller.selectedCategoryFilter.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: controller.categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.onCategoryFilterChanged(newValue);
                        }
                      },
                    ),
                  ),
                ),
              )),

          const SizedBox(width: 12),

          // Search Box
          Expanded(
            child: Obx(() {
              return AppTextField(
                controller: TextEditingController(text: controller.searchQuery.value),
                onChanged: controller.onSearchChanged,
                appTextFieldEnum: AppTextFieldEnum.field,
                hint: "Cari Bahan",
              );
              // return Container(
              //     height: 40,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(4),
              //       border: Border.all(color: const Color(0xFFE0E0E0)),
              //     ),
              //     child: TextField(
              //       controller: TextEditingController(text: controller.searchQuery.value),
              //       onChanged: controller.onSearchChanged,
              //       decoration: const InputDecoration(
              //         contentPadding: EdgeInsets.symmetric(horizontal: 12),
              //         hintText: 'Cari Bahan',
              //         hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
              //         border: InputBorder.none,
              //         suffixIcon: Icon(Icons.search, color: Color(0xFFBDBDBD)),
              //       ),
              //     ),
              //   );
            }),
          ),

          const SizedBox(width: 12),

          // Cari Button
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                // Refresh data dengan filter yang sudah dipilih
                controller.refreshData();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1B9851),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Cari'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 300, // Tetapkan tinggi minimum untuk empty state
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data bahan ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambah bahan baru atau ubah filter pencarian',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Nama Bahan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Unit Pembelian',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Harga Saat Ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Pembelian',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Penjualan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Stok Saat Ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Bar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Action',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(InventoryItem item) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.unit,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rp${item.currentPrice}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.purchases.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.sales.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.currentStock.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Container(
                    width: (item.stockPercentage < 0.05
                        ? 5 // Minimum size for visibility
                        : 120 * item.stockPercentage),
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStockBarColor(item.stockPercentage),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: controller.showItemActionMenu(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prev button
              _buildPaginationButton('Prev', controller.currentPage.value > 1, () {
                if (controller.currentPage.value > 1) {
                  controller.onPageChanged(controller.currentPage.value - 1);
                }
              }),

              // Page numbers
              ...List.generate(
                controller.totalPages.value > 5 ? 3 : controller.totalPages.value,
                (index) {
                  final pageNum = index + 1;
                  return _buildPageButton(
                    pageNum,
                    pageNum == controller.currentPage.value,
                    () => controller.onPageChanged(pageNum),
                  );
                },
              ),

              // Ellipsis if needed
              if (controller.totalPages.value > 5)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Text('...'),
                ),

              // Last page if many pages
              if (controller.totalPages.value > 5)
                _buildPageButton(
                  controller.totalPages.value,
                  controller.totalPages.value == controller.currentPage.value,
                  () => controller.onPageChanged(controller.totalPages.value),
                ),

              // Next button
              _buildPaginationButton('Next', controller.currentPage.value < controller.totalPages.value, () {
                if (controller.currentPage.value < controller.totalPages.value) {
                  controller.onPageChanged(controller.currentPage.value + 1);
                }
              }),
            ],
          ),
        ));
  }

  Widget _buildPaginationButton(String label, bool enabled, VoidCallback onPressed) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: enabled ? const Color(0xFFEAEEF2) : const Color(0xFFEEEEEE),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: enabled ? Colors.black : const Color(0xFFCCCCCC),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton(int page, bool isSelected, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B9851) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B9851) : const Color(0xFFEAEEF2),
          ),
        ),
        child: Center(
          child: Text(
            page.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStockBarColor(double percentage) {
    if (percentage < 0.3) {
      return const Color(0xFFDF0000); // Red for low stock
    } else if (percentage < 0.6) {
      return const Color(0xFFFFB200); // Amber for medium stock
    } else {
      return const Color(0xFF1B9851); // Green for good stock
    }
  }
}

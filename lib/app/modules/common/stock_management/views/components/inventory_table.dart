import 'package:flutter/material.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../core/utils.dart';
import '../../data/models/inventory_item_model.dart';

class InventoryTable extends StatelessWidget {
  final List<InventoryItem> items;
  final bool isLoading;
  final Function(String) onSort;
  final Function(InventoryItem) onAction;

  const InventoryTable({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onSort,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data bahan ditemukan',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambah bahan baru atau ubah filter pencarian',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: const Color(0xFFD1D1D1)),
          ),
          child: Row(
            children: [
              _buildHeaderCell('Nama Bahan', 'name', 180),
              _buildHeaderCell('Unit Pembelian', 'unit', 122),
              _buildHeaderCell('Harga Saat ini', 'price', 145.25),
              _buildHeaderCell('Pembelian', 'purchases', 145.25),
              _buildHeaderCell('Penjualan', 'sales', 145.25),
              _buildHeaderCell('Stok Saat ini', 'stock', 145.25),
              _buildHeaderCell('Bar', '', 160),
              const SizedBox(width: 75, child: Center(child: Text('Action'))),
            ],
          ),
        ),

        // Rows
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    bottom: BorderSide(
                      color: index == items.length - 1 ? Colors.transparent : const Color(0xFFEDEDED),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(item.name, style: AppTextStyles.bodyMedium),
                    ),
                    SizedBox(
                      width: 122,
                      child: Text(item.unit, style: AppTextStyles.bodyMedium),
                    ),
                    SizedBox(
                      width: 145.25,
                      child: Text(
                        CurrencyFormatter.formatRupiah(item.currentPrice),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      width: 145.25,
                      child: Text(
                        CurrencyFormatter.formatThousands(item.purchases.toDouble(), decimalDigits: 0),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      width: 145.25,
                      child: Text(
                        CurrencyFormatter.formatThousands(item.sales.toDouble(), decimalDigits: 0),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      width: 145.25,
                      child: Text(
                        CurrencyFormatter.formatThousands(item.currentStock.toDouble(), decimalDigits: 0),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: (item.stockPercentage < 0.2
                                  ? 160 * 0.2 // Minimum size for visibility
                                  : 160 * item.stockPercentage),
                              height: 6,
                              decoration: BoxDecoration(
                                color: _getStockBarColor(item.stockPercentage),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 75,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () => onAction(item),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: const BorderSide(color: Color(0xFFEAEEF2)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Pagination
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaginationButton('Prev', false),
              _buildPageButton(1, true),
              _buildPageButton(2, false),
              _buildPageButton(3, false),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('...'),
              ),
              _buildPageButton(10, false),
              _buildPaginationButton('Next', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String label, String column, double width) {
    return GestureDetector(
      onTap: () => onSort(column),
      child: SizedBox(
        width: width,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildPaginationButton(String label, bool enabled) {
    return Container(
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
    );
  }

  Widget _buildPageButton(int page, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF136C3A) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? const Color(0xFF136C3A) : const Color(0xFFEAEEF2),
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

// lib/app/modules/common/inventory/views/inventory_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/layout/tab_container.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TabItem(
        title: 'Daftar Bahan',
        content: _buildItemsContent(),
      ),
      TabItem(
        title: 'Riwayat Transaksi',
        content: _buildTransactionsContent(),
      ),
      TabItem(
        title: 'Laporan Stok',
        content: _buildReportsContent(),
      ),
    ];

    return AppLayout(
      content: Padding(
        padding: AppDimensions.contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Manajemen Inventori',
                  style: AppTextStyles.h2,
                ),
                Row(
                  children: [
                    AppButton(
                      label: 'Catat Stok Masuk',
                      prefixSvgPath: AppIcons.add,
                      variant: ButtonVariant.primary,
                      onPressed: () => Get.toNamed(Routes.STOCK_IN),
                      fullWidth: false,
                      width: 160,
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      label: 'Catat Stok Keluar',
                      prefixSvgPath: AppIcons.trashCan,
                      variant: ButtonVariant.outline,
                      onPressed: () => Get.toNamed(Routes.STOCK_OUT),
                      fullWidth: false,
                      width: 160,
                      outlineBorderColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tab container with content
            Expanded(
              child: TabContainer(
                tabs: tabs,
                onTabChanged: (index) {
                  // You can add logic here if needed when tab changes
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsContent() {
    return Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and filter row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: InputBorder.none,
                          hintText: 'Cari bahan',
                          prefixIcon: Icon(Icons.search, size: 20),
                        ),
                        onChanged: (value) {
                          controller.searchQuery.value = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Category filter dropdown
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text('Semua Kategori'),
                        value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
                        items: ['Semua Kategori', ...controller.categories]
                            .map((category) => DropdownMenuItem<String>(
                                  value: category == 'Semua Kategori' ? '' : category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.selectedCategory.value = value ?? '';
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Inventory items table
              Expanded(
                child: _buildInventoryTable(),
              ),
            ],
          ));
  }

  Widget _buildInventoryTable() {
    // Build table headers
    final filteredItems = controller.getFilteredItems();

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  'Nama Bahan',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: AppText(
                  'Kategori',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: AppText(
                  'Stok',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: AppText(
                  'Status',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 80),
            ],
          ),
        ),

        // Table body
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: filteredItems.isEmpty
                ? const Center(
                    child: AppText('Tidak ada data inventori'),
                  )
                : ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final stock = int.parse(item['stock'].toString());
                      final isLowStock = stock < 1000; // Example threshold

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        color: index % 2 == 0 ? Colors.white : AppColors.background.withOpacity(0.3),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: AppText(item['name'].toString()),
                            ),
                            Expanded(
                              child: AppText(item['category'].toString()),
                            ),
                            Expanded(
                              child: AppText('${item['stock']} ${item['unit']}'),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isLowStock ? AppColors.warningLight : AppColors.successLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AppText(
                                  isLowStock ? 'Stok Rendah' : 'Stok Cukup',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isLowStock ? AppColors.warning : AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () => _showEditItemDialog(item),
                                    tooltip: 'Edit',
                                    padding: EdgeInsets.zero,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, size: 20),
                                    onPressed: () => _showItemDetails(item),
                                    tooltip: 'Lihat Detail',
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    // Implement edit item dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Edit Bahan',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 24),
              AppText('Fitur ini akan diimplementasikan selanjutnya.'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: 'Tutup',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                  fullWidth: false,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    // Implement item details dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Detail Bahan',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column - basic info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Nama Bahan', item['name'].toString()),
                        _buildInfoRow('Kategori', item['category'].toString()),
                        _buildInfoRow('Stok Saat Ini', '${item['stock']} ${item['unit']}'),
                        _buildInfoRow('Status', int.parse(item['stock'].toString()) < 1000 ? 'Stok Rendah' : 'Stok Cukup'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right column - additional info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Harga Terakhir', 'Rp 25.000 / kg'),
                        _buildInfoRow('Supplier', 'PT Supplier Makanan'),
                        _buildInfoRow('Terakhir Diperbarui', '15 Jan 2025'),
                        _buildInfoRow('Kode Barang', 'BHN-${item['id']}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stock movement chart (placeholder)
              AppCard(
                title: 'Pergerakan Stok',
                child: Container(
                  height: 200,
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: const AppText('Grafik pergerakan stok akan ditampilkan di sini'),
                ),
              ),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: 'Tutup',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                  fullWidth: false,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          AppText(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsContent() {
    return Obx(() => controller.isLoadingTransactions.value
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date range picker
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          const AppText('Periode: '),
                          AppText(
                            controller.dateRangeText.value,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down, size: 20),
                            onPressed: () => controller.showDatePicker(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Transaction type filter
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text('Semua Transaksi'),
                        value: controller.selectedTransactionType.value.isEmpty ? null : controller.selectedTransactionType.value,
                        items: ['Semua Transaksi', 'Stok Masuk', 'Stok Keluar']
                            .map((type) => DropdownMenuItem<String>(
                                  value: type == 'Semua Transaksi' ? '' : type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.selectedTransactionType.value = value ?? '';
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transactions table
              Expanded(
                child: _buildTransactionsTable(),
              ),
            ],
          ));
  }

  Widget _buildTransactionsTable() {
    // Get filtered transactions
    final transactions = controller.getFilteredTransactions();

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AppText(
                  'Tanggal',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText(
                  'Tipe',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: AppText(
                  'Deskripsi',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText(
                  'Jumlah',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText(
                  'Harga',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Table body
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: transactions.isEmpty
                ? const Center(
                    child: AppText('Tidak ada data transaksi'),
                  )
                : ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final isStockIn = transaction['type'] == 'Stok Masuk';

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        color: index % 2 == 0 ? Colors.white : AppColors.background.withOpacity(0.3),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AppText(transaction['date']),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isStockIn ? AppColors.successLight : AppColors.errorLight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: AppText(
                                      transaction['type'],
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: isStockIn ? AppColors.success : AppColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: AppText(transaction['description']),
                            ),
                            Expanded(
                              flex: 1,
                              child: AppText(
                                '${transaction['quantity']} ${transaction['unit']}',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AppText(
                                transaction['price'],
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline, size: 20),
                                onPressed: () => _showTransactionDetails(transaction),
                                tooltip: 'Lihat Detail',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    // Show transaction details dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Detail Transaksi',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Tanggal', transaction['date']),
                        _buildInfoRow('Tipe Transaksi', transaction['type']),
                        _buildInfoRow('Item', transaction['item']),
                        _buildInfoRow('Kategori', transaction['category']),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Jumlah', '${transaction['quantity']} ${transaction['unit']}'),
                        _buildInfoRow('Harga', transaction['price']),
                        _buildInfoRow('Pengguna', transaction['user']),
                        _buildInfoRow('Catatan', transaction['notes']),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: 'Tutup',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                  fullWidth: false,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Laporan Inventori',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 16),

        // Report cards
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2,
            children: [
              _buildReportCard(
                title: 'Laporan Nilai Inventori',
                description: 'Laporan nilai total inventori dan distribusi berdasarkan kategori',
                icon: Icons.monetization_on,
                onTap: () => _showReportNotImplemented(),
              ),
              _buildReportCard(
                title: 'Laporan Pergerakan Stok',
                description: 'Analisis pergerakan stok masuk dan keluar per periode',
                icon: Icons.trending_up,
                onTap: () => _showReportNotImplemented(),
              ),
              _buildReportCard(
                title: 'Laporan Stok Minimum',
                description: 'Daftar bahan dengan stok di bawah batas minimum',
                icon: Icons.warning,
                onTap: () => _showReportNotImplemented(),
              ),
              _buildReportCard(
                title: 'Laporan Penggunaan Bahan',
                description: 'Analisis penggunaan bahan per kategori dan item',
                icon: Icons.pie_chart,
                onTap: () => _showReportNotImplemented(),
              ),
              _buildReportCard(
                title: 'Laporan Supplier',
                description: 'Daftar pembelian stok per supplier',
                icon: Icons.people,
                onTap: () => _showReportNotImplemented(),
              ),
              _buildReportCard(
                title: 'Laporan Kadaluarsa',
                description: 'Daftar bahan yang mendekati tanggal kadaluarsa',
                icon: Icons.access_time,
                onTap: () => _showReportNotImplemented(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        description,
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReportNotImplemented() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Fitur Dalam Pengembangan',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 16),
              const AppText(
                'Laporan ini masih dalam tahap pengembangan dan akan segera tersedia pada versi mendatang.',
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: 'Tutup',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                  fullWidth: false,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

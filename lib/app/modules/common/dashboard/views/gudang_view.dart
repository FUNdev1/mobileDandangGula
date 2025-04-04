import 'package:dandang_gula/app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global_widgets/charts/total_income_chart.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../global_widgets/layout/tab_container.dart';
import '../../../../global_widgets/charts/category_chart.dart';
import '../../../../global_widgets/charts/stock_flow_chart.dart';
import '../../../../global_widgets/charts/stock_usage_chart.dart';
import '../../../../global_widgets/table/payment_method_table.dart';
import '../../../../global_widgets/table/product_sales_table.dart';
import '../../../../global_widgets/table/stock_alert_table.dart';
import '../../../../global_widgets/card/summary_card.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/filter/period_filter.dart';
import '../../../../routes/app_routes.dart';

class GudangDashboardView extends StatelessWidget {
  final DashboardController controller;

  const GudangDashboardView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInventoryContent(),
        ],
      ),
    );
  }

  // Inventory content
  Widget _buildInventoryContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period filter with stock purchase button
          PeriodFilter(
            controller: controller.periodFilterController,
            onPeriodChanged: (periodId) {
              controller.onPeriodFilterChanged(periodId);
            },
            actionButton: [
              const Spacer(),
              AppButton(
                label: "Catat Pembelian Stok",
                width: 200,
                variant: ButtonVariant.secondary,
                prefixSvgPath: AppIcons.shoppingBag,
                onPressed: () {
                },
              )
            ],
          ),
          const SizedBox(height: 16),

          // Total Bahan card - improved with better formatting
          AppCard(
            title: "Total Bahan",
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() => AppText(
                      "${controller.totalBranches.value * 40}",
                      style: AppTextStyles.h1,
                    )),
                const SizedBox(width: 8),
                AppText(
                  "Items",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stok Masuk & Stok Terbuang cards
          Row(
            children: [
              // Stok Masuk
              Expanded(
                child: AppCard(
                  title: 'Stok Masuk',
                  action: const AppText(
                    'Hari ini',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText('Jumlah items'),
                      // AppText(
                      //   '${controller.stockEntryCountToday}',
                      //   style: AppTextStyles.h3,
                      // ),
                      const SizedBox(height: 8),
                      const AppText('Total'),
                      // AppText(
                      //   CurrencyFormatter.formatRupiah(controller.stockEntryValueToday),
                      //   style: AppTextStyles.h3,
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Stok Terbuang
              Expanded(
                child: AppCard(
                  title: 'Stok Terbuang',
                  action: const AppText(
                    'Hari ini',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bars untuk alasan pembuangan stok
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText('Expired'),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: 0.7,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          const AppText('Kesalahan Produksi'),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: 0.4,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          const AppText('Lain-lain'),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: 0.2,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            minHeight: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Statistik arus stok
          AppCard(
            title: 'Statistik arus stok',
            action: const AppText('Hari ini - Pk 00:00 (GMT+07)'),
            child: SizedBox(
              height: 250,
              child: Obx(() => controller.stockFlowData.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : StockFlowChart(
                      data: controller.stockFlowData,
                    )),
            ),
          ),
          const SizedBox(height: 24),

          // Stock Alert
          Obx(() => StockAlertTable(
                title: 'Stock alert',
                stockAlerts: controller.stockAlerts,
                onViewAll: () {
                  // Navigate to stock alert page
                  // Get.toNamed(Routes.INVENTORY);
                },
              )),
          const SizedBox(height: 24),

          // Penggunaan Stok by Group dengan pie chart
          AppCard(
            title: 'Penggunaan Stok bahan by Group',
            action: const AppText(
              'Hari ini',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Obx(() => controller.stockUsageData.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : StockUsageChart(
                          data: controller.stockUsageData,
                          isDoughnut: true,
                        )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Tambah Stok',
                prefixSvgPath: AppIcons.add,
                variant: ButtonVariant.primary,
                onPressed: () {
                  // Navigate to stock in page
                  Get.toNamed(Routes.STOCK_MANAGEMENT_ADD);
                },
                fullWidth: false,
                width: 150,
              ),
              const SizedBox(width: 16),
              AppButton(
                label: 'Download Laporan',
                prefixSvgPath: AppIcons.download,
                variant: ButtonVariant.outline,
                onPressed: () {
                  // Show download options dialog
                  _showDownloadOptionsDialog();
                },
                fullWidth: false,
                width: 180,
                outlineBorderColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDownloadOptionsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Download Laporan',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 16),
              AppText(
                'Pilih format laporan yang ingin diunduh:',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Format options
              _buildDownloadOption(
                icon: Icons.picture_as_pdf,
                title: 'PDF',
                subtitle: 'Laporan dalam format PDF',
                onTap: () {
                  Get.back();
                  // Show loading snackbar
                  Get.snackbar(
                    'Mengunduh Laporan',
                    'Laporan sedang diunduh dalam format PDF',
                    backgroundColor: AppColors.success,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildDownloadOption(
                icon: Icons.table_chart,
                title: 'Excel',
                subtitle: 'Laporan dalam format Excel (XLSX)',
                onTap: () {
                  Get.back();
                  // Show loading snackbar
                  Get.snackbar(
                    'Mengunduh Laporan',
                    'Laporan sedang diunduh dalam format Excel',
                    backgroundColor: AppColors.success,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildDownloadOption(
                icon: Icons.print,
                title: 'Print',
                subtitle: 'Cetak laporan langsung',
                onTap: () {
                  Get.back();
                  // Show printer dialog (mock)
                  Get.snackbar(
                    'Menyiapkan Printer',
                    'Menyiapkan dokumen untuk dicetak',
                    backgroundColor: AppColors.info,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: AppText(
                    'Batal',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
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
                  AppText(
                    subtitle,
                    style: AppTextStyles.bodySmall,
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
      ),
    );
  }
}

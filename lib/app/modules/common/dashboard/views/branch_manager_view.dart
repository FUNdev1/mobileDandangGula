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
import '../../../../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/supervisor_dashboard_controller.dart';
import '../widgets/filter/period_filter.dart';

class BranchManagerDashboardView extends StatelessWidget {
  final controller = DashboardController.to as SupervisorDashboardController;

  BranchManagerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TabItem(
        title: 'Penjualan',
        content: _buildSalesContent(),
      ),
      TabItem(
        title: 'Inventori Gudang',
        content: _buildInventoryContent(),
      ),
    ];

    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period filter
          // Tab container with the content tabs
          TabContainer(
            tabs: tabs,
            onTabChanged: (index) {
              // Handle tab changes if needed
              print('Tab changed to index $index');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Sales content tab
  Widget _buildSalesContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PeriodFilter(
            controller: controller.periodFilterController,
            onPeriodChanged: (periodId) {
              controller.onPeriodFilterChanged(periodId);
            },
          ),
          const SizedBox(height: 16),

          // Total Sales & Orders Overview
          Row(
            children: [
              Column(
                children: [
                  SummaryCard(
                    title: 'Total Pendapatan',
                    subtitle: 'Total',
                    value: 'Rp 50.000.000',
                    cogsLabel: 'COGS',
                    cogsValue: 'Rp 45.000.000',
                    profitLabel: 'Laba Kotor',
                    profitValue: 'Rp 5.000.000',
                  ),
                  const SizedBox(height: 16),
                  SummaryCard(
                    title: 'Total Pesanan',
                    subtitle: 'Total',
                    value: '1,520 Pesanan',
                    height: 134, // Smaller height as per second design
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() {
                  return TotalIncomeChart(
                    data: controller.dashboardRepository.incomeChartData.value,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Penjualan Produk
          SizedBox(
            height: 410,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch all children to fill the row height
              children: [
                Expanded(
                  flex: 2,
                  child: ProductSalesTable(
                    title: 'Penjualan Produk',
                    products: controller.topProducts,
                    onViewAll: () {
                      // Action untuk melihat semua produk
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CategorySalesCard(
                    title: 'Penjualan by kategori',
                    subtitle: 'Hari ini',
                    data: controller.categorySales,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: PaymentMethodTable(
                    title: 'Pendapatan by Metode Pembayaran',
                    paymentMethods: controller.paymentMethods,
                    onViewAll: () {
                      // Action untuk melihat semua metode pembayaran
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Inventory content tab
  Widget _buildInventoryContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PeriodFilter(
            controller: controller.periodFilterController,
            onPeriodChanged: (periodId) {
              controller.onPeriodFilterChanged(periodId);
            },
            actionButton: [
              Spacer(),
              AppButton(
                label: "Catat Pembelian Stok",
                width: 200,
                variant: ButtonVariant.secondary,
              )
            ],
          ),
          const SizedBox(height: 16),

          AppCard(
            title: "Total Bahan",
            child: Row(
              children: [
                AppText("120"),
              ],
            ),
          ),

          // Inventory stats
          // Row(
          //   children: [
          //     Expanded(
          //       child: SummaryCard(
          //         title: 'Total Bahan',
          //         value: '${controller.totalBranches.value * 40}',
          //         secondaryValue: 'Items',
          //         icon: Icons.category,
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //     Expanded(
          //         child: SummaryCard(
          //       title: 'Stok Rendah',
          //       value: '${controller.lowStockItems.value}',
          //       secondaryValue: 'Items',
          //       icon: Icons.warning,
          //     )),
          //   ],
          // ),
          const SizedBox(height: 16),

          // Stok Masuk & Stok Terbuang
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
                      AppText(
                        '15',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 8),
                      const AppText('Total'),
                      AppText(
                        'Rp 1.000.000',
                        style: AppTextStyles.h3,
                      ),
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
              child: StockFlowChart(
                data: controller.stockFlowData,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stock Alert
          StockAlertTable(
            title: 'Stock alert',
            stockAlerts: controller.stockAlerts,
            onViewAll: () {
              // Action untuk melihat semua stock alert
            },
          ),
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
                  child: StockUsageChart(
                    data: controller.stockUsageData,
                    isDoughnut: true,
                  ),
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
                onPressed: () {},
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
}

import 'package:dandang_gula/app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global_widgets/charts/total_income_chart.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_dimensions.dart';
import '../../../../core/utils/theme/app_text_styles.dart';
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
                label: "Download Data",
                prefixSvgPath: AppIcons.download,
                variant: ButtonVariant.outline,
                onPressed: () {},
                width: 160,
                outlineBorderColor: AppColors.primary,
              ),
              const SizedBox(width: 12),
              AppButton(
                label: "Catat Pembelian Stok",
                width: 200,
                variant: ButtonVariant.secondary,
                onPressed: () {
                  // Navigasi ke halaman catat pembelian stok
                  Get.toNamed(Routes.STOCK_MANAGEMENT_ADD);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 209,
                          child: AppCard(
                            title: "Total Bahan",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(controller.totalStockItems.toString(), style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w600)),
                                AppText("Items", style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 209,
                          child: AppCard(
                            title: "Stok Masuk",
                            action: const AppText(
                              'Hari ini',
                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText('Jumlah items', style: AppTextStyles.bodyMedium),
                                AppText(controller.stockInItemsToday.toString(), style: AppTextStyles.h3),
                                const SizedBox(height: 8),
                                AppText('Total', style: AppTextStyles.bodyMedium),
                                AppText('Rp ' + controller.stockInTotalToday.toString(), style: AppTextStyles.h3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppCard(
                      title: 'Statistik arus stok',
                      action: const AppText('Hari ini - Pk 00:00 (GMT+07)'),
                      child: SizedBox(
                        height: 180,
                        child: StockFlowChart(
                          data: controller.stockFlowData,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StockAlertTable(
                  title: 'Stock alert',
                  stockAlerts: controller.stockAlerts,
                  onViewAll: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppCard(
                  title: 'Metric Stock usage',
                  child: SizedBox(
                    height: 200,
                    child: StockUsageChart(
                      data: controller.stockUsageData,
                      isDoughnut: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: AppCard(
                  title: 'Penggunaan Stok bahan by Group',
                  action: const AppText(
                    'Hari ini',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: StockUsageChart(
                      data: controller.stockUsageData,
                      isDoughnut: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

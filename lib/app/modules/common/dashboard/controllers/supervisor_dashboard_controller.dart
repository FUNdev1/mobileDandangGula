import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/models/chart_data_model.dart';
import '../../../../data/models/category_sales_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../data/models/product_sales_model.dart';
import '../../../../data/models/revenue_expense_data.dart';
import '../../../../data/models/stock_alert_model.dart';
import '../../../../data/models/stock_flow_data_model.dart';
import '../../../../data/models/stock_usage_model.dart';
import 'base_dashboard_controller.dart';

class SupervisorDashboardController extends BaseDashboardController {
  // Supervisor-specific observable variables
  final dailySales = <ChartData>[].obs;
  final categorySales = <CategorySales>[].obs;
  final topProducts = <ProductSales>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final stockAlerts = <StockAlert>[].obs;
  final stockFlowData = <StockFlowData>[].obs;
  final stockUsageData = <StockUsage>[].obs;
  final revenueExpenseData = <RevenueExpenseData>[].obs;
  final staffPerformance = <Map<String, dynamic>>[].obs;

  @override
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final filterParams = periodFilterController.getFilterParams();

      // Dapatkan data dasar dashboard
      final summary = await dashboardRepository.fetchDashboardSummary(filterParams: filterParams);
      todaySales.value = summary.totalIncome;
      todayProfit.value = summary.netProfit;
      salesGrowth.value = summary.percentChange;

      // Dapatkan data penjualan harian
      // dailySales.value = await dashboardRepository.fetchDailySales(branchId: selectedBranchId.value, filterParams: filterParams);

      // Dapatkan data kategori dan produk
      categorySales.value = await orderRepository.getCategorySales(filterParams: filterParams);
      topProducts.value = await orderRepository.getTopProductSales(filterParams: filterParams);
      paymentMethods.value = await orderRepository.getPaymentMethodData(filterParams: filterParams);

      // Dapatkan data stok
      stockAlerts.value = await stockRepository.getStockAlerts();
      // Dapatkan data flow stok
      stockFlowData.value = await stockRepository.getStockFlowData();
      // Dapatkan data penggunaan stok
      stockUsageData.value = await stockRepository.getStockUsageByGroup();

      // Dapatkan data revenue vs expense
      revenueExpenseData.value = dashboardRepository.revenueExpenseData;

      // Dapatkan data performa staff
      // staffPerformance.value = await dashboardRepository.fetchStaffPerformance(branchId: selectedBranchId.value, filterParams: filterParams);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading supervisor dashboard data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Metode untuk mendapatkan performa staff detail
  Future<void> fetchStaffPerformanceDetails(String staffId) async {
    try {
      final filterParams = periodFilterController.getFilterParams();
      // final staffDetails = await dashboardRepository.fetchStaffPerformanceDetails(staffId: staffId, branchId: selectedBranchId.value, filterParams: filterParams);

      // Tampilkan detail staff atau simpan ke variabel observable
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching staff performance details: $e');
      }
    }
  }

  // Method untuk menangani perubahan filter periode
  @override
  void onPeriodFilterChanged(String periodId) {
    periodFilterController.changePeriod(periodId);
    loadDashboardData();
  }
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/models/report_model.dart';
import '../../../../core/models/stock_model.dart';
import 'base_dashboard_controller.dart';

class AdminDashboardController extends BaseDashboardController {
  // Admin-specific observable variables
  final categorySales = <CategorySales>[].obs;
  final topProducts = <ProductSales>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final stockFlowData = <StockFlowData>[].obs;
  final stockAlertsData = <StockAlert>[].obs;
  final stockUsageData = <StockUsage>[].obs;

  @override
  Future<void> loadDashboardData() async {
    try {
      final filterParams = periodFilterController.getFilterParams();

      // Dapatkan data dasar dashboard
      final summary = await dashboardRepository.fetchDashboardSummary(filterParams: filterParams);
      todaySales.value = summary.totalIncome;
      todayProfit.value = summary.netProfit;
      salesGrowth.value = summary.percentChange;

      // Dapatkan data khusus admin
      // categorySales.value = await orderRepository.getCategorySales(filterParams: filterParams);
      // topProducts.value = await orderRepository.getTopProductSales(filterParams: filterParams);
      // paymentMethods.value = await orderRepository.getPaymentMethodData(filterParams: filterParams);

      // Dapatkan data revenue vs expense
      // await dashboardRepository.fetchRevenueExpenseData(selectedBranchId.value, filterParams: filterParams);

      // Dapatkan data stock flow
      stockFlowData.value = await stockRepository.getStockFlowData();
      // Dapatkan data stock alerts
      stockAlertsData.value = await stockRepository.getStockAlerts();
      // Dapatkan data stock usage
      stockUsageData.value = await stockRepository.getStockUsageByGroup();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading admin dashboard data: $e');
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

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/models/chart_data_model.dart';
import '../../../../data/models/category_sales_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../data/models/product_sales_model.dart';
import 'base_dashboard_controller.dart';

class PusatDashboardController extends BaseDashboardController {
  // Pusat-specific observable variables
  final allBranchSales = <ChartData>[].obs;
  final branchComparison = <ChartData>[].obs;
  final categorySales = <CategorySales>[].obs;
  final topProducts = <ProductSales>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final revenueExpenseData = <ChartData>[].obs;

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

      // Dapatkan data khusus pusat
      await branchRepository.fetchAllBranches();
      if (branchRepository.branches.isNotEmpty) {
        // allBranchSales.value = branchRepository.branches.value
        selectedBranchId.value = branchRepository.branches.first.id;
      }

      // branchComparison.value = await branchRepository.fetchBranchComparison(filterParams: filterParams);

      // Dapatkan data kategori dan produk
      categorySales.value = await orderRepository.getCategorySales(filterParams: filterParams);
      topProducts.value = await orderRepository.getTopProductSales(filterParams: filterParams);
      paymentMethods.value = await orderRepository.getPaymentMethodData(filterParams: filterParams);

      // Dapatkan data revenue vs expense
      // revenueExpenseData.value = await branchRepository.fetchRevenueExpenseData(selectedBranchId.value.isEmpty ? null : selectedBranchId.value, filterParams: filterParams);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading pusat dashboard data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Metode untuk mendapatkan performa cabang
  Future<void> fetchBranchPerformance() async {
    try {
      final filterParams = periodFilterController.getFilterParams();
      // branchComparison.value = await branchRepository.fetchBranchComparison(filterParams: filterParams);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching branch performance: $e');
      }
    }
  }

  // Method untuk menangani perubahan filter periode
  void onPeriodFilterChanged(String periodId) {
    periodFilterController.changePeriod(periodId);
    loadDashboardData();
  }
}

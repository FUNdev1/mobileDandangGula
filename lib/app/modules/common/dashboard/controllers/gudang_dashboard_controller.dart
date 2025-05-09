import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/models/stock_model.dart';
import 'base_dashboard_controller.dart';

class GudangDashboardController extends BaseDashboardController {
  // Gudang-specific observable variables
  final stockAlerts = <StockAlert>[].obs;
  final stockFlowData = <StockFlowData>[].obs;
  final stockUsageData = <StockUsage>[].obs;

  @override
  Future<void> loadDashboardData() async {
    try {
      // Dapatkan data khusus gudang
      stockAlerts.value = await stockRepository.getStockAlerts();
      stockFlowData.value = await stockRepository.getStockFlowData();
      stockUsageData.value = await stockRepository.getStockUsageByGroup();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading gudang dashboard data: $e');
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

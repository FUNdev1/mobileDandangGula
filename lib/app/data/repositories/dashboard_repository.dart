import 'dart:developer';

import 'package:get/get.dart';

import '../models/chart_data_model.dart';
import '../models/revenue_expense_data.dart';
import '../services/api_service.dart';
import 'branch_repository.dart';

class DashboardSummary {
  final double totalIncome;
  final double netProfit;
  final double percentChange;

  DashboardSummary({
    required this.totalIncome,
    required this.netProfit,
    required this.percentChange,
  });
}

abstract class DashboardRepository {
  // Observable values
  Rx<DashboardSummary> get dashboardSummary;
  RxList<ChartData> get incomeChartData;
  RxList<RevenueExpenseData> get revenueExpenseData;

  // Methods
  Future<DashboardSummary> fetchDashboardSummary({Map<String, dynamic>? filterParams});
  Future<void> fetchRevenueExpenseData(String branchId, {Map<String, dynamic>? filterParams});
  Future<void> fetchSalesPerformanceData(String branchId, {Map<String, dynamic>? filterParams});
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams});
  Future<double> getTotalProfit({Map<String, dynamic>? filterParams});
  Future<double> getRevenueGrowth({Map<String, dynamic>? filterParams});
  Future<List<ChartData>> getRevenueChartData({Map<String, dynamic>? filterParams});
}

class DashboardRepositoryImpl implements DashboardRepository {
  final BranchRepository _branchRepository = Get.find<BranchRepository>();
  final ApiService _apiService = Get.find<ApiService>();

  final _salesPerformanceCache = <String, List<ChartData>>{};

  @override
  final dashboardSummary = Rx<DashboardSummary>(
    DashboardSummary(
      totalIncome: 0,
      netProfit: 0,
      percentChange: 0,
    ),
  );

  @override
  final incomeChartData = <ChartData>[].obs;

  @override
  final revenueExpenseData = <RevenueExpenseData>[].obs;

  @override
  Future<DashboardSummary> fetchDashboardSummary({Map<String, dynamic>? filterParams}) async {
    try {
      // Tidak ada endpoint spesifik, gunakan endpoint terdekat atau mock API
      final response = await _apiService.get('/dashboard/summary', queryParams: filterParams);

      if (response is Map) {
        dashboardSummary.value = DashboardSummary(
          totalIncome: response['totalIncome'] != null ? double.parse(response['totalIncome'].toString()) : 0.0,
          netProfit: response['netProfit'] != null ? double.parse(response['netProfit'].toString()) : 0.0,
          percentChange: response['percentChange'] != null ? double.parse(response['percentChange'].toString()) : 0.0,
        );
      }

      dashboardSummary.refresh();
      return dashboardSummary.value;
    } catch (e) {
      log('Error fetching dashboard summary: $e');
      return dashboardSummary.value;
    }
  }

  @override
  Future<void> fetchRevenueExpenseData(String branchId, {Map<String, dynamic>? filterParams}) async {
    try {
      final data = await _branchRepository.getBranchRevenueExpenseData(
        branchId,
        filterParams: filterParams,
      );
      revenueExpenseData.value = data;
    } catch (e) {
      log('Error fetching revenue expense data: $e');
    }
  }

  @override
  Future<void> fetchSalesPerformanceData(String branchId, {Map<String, dynamic>? filterParams}) async {
    try {
      if (_salesPerformanceCache.containsKey(branchId)) {
        incomeChartData.value = _salesPerformanceCache[branchId]!;
        return;
      }

      final response = await _apiService.get('/dashboard/sales-performance/$branchId', queryParams: filterParams);

      if (response is List) {
        final data = response.map((item) => ChartData.fromJson(item)).toList();
        _salesPerformanceCache[branchId] = data;
        incomeChartData.value = data;
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        final data = (response['data'] as List).map((item) => ChartData.fromJson(item)).toList();
        _salesPerformanceCache[branchId] = data;
        incomeChartData.value = data;
      }
    } catch (e) {
      log('Error fetching sales performance data: $e');
    }
  }

  @override
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/dashboard/total-revenue', queryParams: filterParams);

      if (response is Map && response.containsKey('revenue')) {
        return double.parse(response['revenue'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting total revenue: $e');
      return 0.0;
    }
  }

  @override
  Future<double> getTotalProfit({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/dashboard/total-profit', queryParams: filterParams);

      if (response is Map && response.containsKey('profit')) {
        return double.parse(response['profit'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting total profit: $e');
      return 0.0;
    }
  }

  @override
  Future<double> getRevenueGrowth({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/dashboard/revenue-growth', queryParams: filterParams);

      if (response is Map && response.containsKey('growth')) {
        return double.parse(response['growth'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting revenue growth: $e');
      return 0.0;
    }
  }

  @override
  Future<List<ChartData>> getRevenueChartData({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/dashboard/revenue-chart', queryParams: filterParams);

      if (response is List) {
        return response.map((item) => ChartData.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ChartData.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting revenue chart data: $e');
      return [];
    }
  }
}

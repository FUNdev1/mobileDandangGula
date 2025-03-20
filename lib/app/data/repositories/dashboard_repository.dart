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

  // Cache data per branch
  final _salesPerformanceCache = <String, List<ChartData>>{};

  // Observable values
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

  // Fetch dashboard summary data
  @override
  Future<DashboardSummary> fetchDashboardSummary({Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get('/dashboard/summary');

    dashboardSummary.value = DashboardSummary(
      totalIncome: response['totalIncome'] ?? 0.0,
      netProfit: response['netProfit'] ?? 0.0,
      percentChange: response['percentChange'] ?? 0.0,
    );

    dashboardSummary.refresh();
    return dashboardSummary.value;
  }

  // Fetch revenue vs expense data for a specific branch
  @override
  Future<void> fetchRevenueExpenseData(String branchId, {Map<String, dynamic>? filterParams}) async {
    final data = await _branchRepository.getBranchRevenueExpenseData(
      branchId,
      filterParams: filterParams,
    );
    revenueExpenseData.value = data;
  }

  // Fetch sales performance data for a specific branch
  @override
  Future<void> fetchSalesPerformanceData(String branchId, {Map<String, dynamic>? filterParams}) async {
    // Return cached data if available
    if (_salesPerformanceCache.containsKey(branchId)) {
      incomeChartData.value = _salesPerformanceCache[branchId]!;
      return;
    }

    final response = await _apiService.get('/dashboard/sales-performance/$branchId', queryParams: filterParams);
    final data = (response as List).map((item) => ChartData.fromJson(item)).toList();

    _salesPerformanceCache[branchId] = data;
    incomeChartData.value = data;
  }

  @override
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get(
      '/dashboard/total-revenue',
      queryParams: filterParams,
    );
    return response['revenue'] ?? 0.0;
  }

  @override
  Future<double> getTotalProfit({Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get(
      '/dashboard/total-profit',
      queryParams: filterParams,
    );
    return response['profit'] ?? 0.0;
  }

  @override
  Future<double> getRevenueGrowth({Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get(
      '/dashboard/revenue-growth',
      queryParams: filterParams,
    );
    return response['growth'] ?? 0.0;
  }

  @override
  Future<List<ChartData>> getRevenueChartData({Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get(
      '/dashboard/revenue-chart',
      queryParams: filterParams,
    );
    return (response as List).map((item) => ChartData.fromJson(item)).toList();
  }
}

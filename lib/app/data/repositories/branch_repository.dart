import 'package:get/get.dart';
import '../models/branch_model.dart';
import '../models/chart_data_model.dart';
import '../models/revenue_expense_data.dart';
import '../services/api_service.dart';

abstract class BranchRepository {
  RxList<Branch> get branches;
  Future<void> fetchAllBranches();
  Branch? getBranchById(String id);
  Future<void> addBranch(Branch branch);
  Future<void> updateBranch(Branch branch);
  Future<void> deleteBranch(String id);
  Future<Map<String, double>> getBranchRevenue(String id, {Map<String, dynamic>? filterParams});
  Future<List<ChartData>> getBranchRevenueChartData(String id, {Map<String, dynamic>? filterParams});
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id, {Map<String, dynamic>? filterParams});
}

class BranchRepositoryImpl extends BranchRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Observable list of branches
  @override
  final RxList<Branch> branches = <Branch>[].obs;

  // Fetch all branches
  @override
  Future<void> fetchAllBranches() async {
    final response = await _apiService.get('/branches');
    final List<Branch> branchList = (response as List).map((item) => Branch.fromJson(item)).toList();
    branches.assignAll(branchList);
  }

  // Get a branch by ID
  @override
  Branch? getBranchById(String id) {
    try {
      return branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      // No branch found with the given ID
      return null;
    }
  }

  // Add a new branch
  @override
  Future<void> addBranch(Branch branch) async {
    final response = await _apiService.post(
      '/branches',
      body: branch.toJson(),
    );

    // Add the new branch with the ID from the server
    final newBranch = Branch.fromJson(response);
    branches.add(newBranch);
    branches.refresh();
  }

  // Update a branch
  @override
  Future<void> updateBranch(Branch branch) async {
    await _apiService.put(
      '/branches/${branch.id}',
      body: branch.toJson(),
    );

    final index = branches.indexWhere((b) => b.id == branch.id);
    if (index != -1) {
      branches[index] = branch;
    }
    branches.refresh();
  }

  // Delete a branch
  @override
  Future<void> deleteBranch(String id) async {
    await _apiService.delete('/branches/$id');
    branches.removeWhere((branch) => branch.id == id);
    branches.refresh();
  }

  @override
  Future<Map<String, double>> getBranchRevenue(String id, {Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get('/branches/$id/revenue');

    return {
      'revenue': response['revenue'] ?? 0.0,
      'cogs': response['cogs'] ?? 0.0,
      'netProfit': response['netProfit'] ?? 0.0,
      'growth': response['growth'] ?? 0.0,
    };
  }

  @override
  Future<List<ChartData>> getBranchRevenueChartData(String id, {Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get('/branches/$id/chart');
    return (response as List).map((item) => ChartData.fromJson(item)).toList();
  }

  @override
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id, {Map<String, dynamic>? filterParams}) async {
    final response = await _apiService.get('/branches/$id/revenue-expense');
    return (response as List).map((item) => RevenueExpenseData.fromJson(item)).toList();
  }
}

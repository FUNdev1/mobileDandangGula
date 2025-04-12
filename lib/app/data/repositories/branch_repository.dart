import 'dart:developer';

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

  @override
  final RxList<Branch> branches = <Branch>[].obs;

  @override
  Future<Map<String, dynamic>> fetchAllBranches() async {
    try {
      final response = await _apiService.get('/branch/lists');
      if (response is List) {
        branches.assignAll(response.map((item) => Branch.fromJson(item)).toList());
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        branches.assignAll((response['data'] as List).map((item) => Branch.fromJson(item)).toList());
      }
      return response;
    } catch (e) {
      log('Error fetching branches: $e');
      return {};
    }
  }

  @override
  Branch? getBranchById(String id) {
    try {
      return branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addBranch(Branch branch) async {
    try {
      final data = {
        'kode': branch.id,
        'name': branch.name,
        'address': branch.address ?? '',
        'status': 'Active',
      };

      if (branch.photoUrl != null && branch.photoUrl!.isNotEmpty) {
        data['photo'] = branch.photoUrl!;
      }

      await _apiService.post('/branch/create', body: data);

      await fetchAllBranches(); // Refresh branch list
    } catch (e) {
      log('Error adding branch: $e');
      throw Exception('Failed to add branch: $e');
    }
  }

  @override
  Future<void> updateBranch(Branch branch) async {
    try {
      final data = {
        'kode': branch.id,
        'name': branch.name,
        'address': branch.address ?? '',
        'status': 'Active',
      };

      if (branch.photoUrl != null && branch.photoUrl!.isNotEmpty) {
        data['photo'] = branch.photoUrl!;
      }

      await _apiService.post('/branch/update/${branch.id}', body: data);

      final index = branches.indexWhere((b) => b.id == branch.id);
      if (index != -1) {
        branches[index] = branch;
      }
      branches.refresh();
    } catch (e) {
      log('Error updating branch: $e');
      throw Exception('Failed to update branch: $e');
    }
  }

  @override
  Future<void> deleteBranch(String id) async {
    try {
      await _apiService.delete('/branch/delete/$id');
      branches.removeWhere((branch) => branch.id == id);
      branches.refresh();
    } catch (e) {
      log('Error deleting branch: $e');
      throw Exception('Failed to delete branch: $e');
    }
  }

  @override
  Future<Map<String, double>> getBranchRevenue(String id, {Map<String, dynamic>? filterParams}) async {
    // Tidak ada endpoint spesifik di Postman collection, jadi menggunakan mock data untuk sementara
    try {
      final response = await _apiService.get('/branch/revenue/$id', queryParams: filterParams);

      if (response is Map) {
        return {
          'revenue': response['revenue'] != null ? double.parse(response['revenue'].toString()) : 0.0,
          'cogs': response['cogs'] != null ? double.parse(response['cogs'].toString()) : 0.0,
          'netProfit': response['netProfit'] != null ? double.parse(response['netProfit'].toString()) : 0.0,
          'growth': response['growth'] != null ? double.parse(response['growth'].toString()) : 0.0,
        };
      }

      return {
        'revenue': 0.0,
        'cogs': 0.0,
        'netProfit': 0.0,
        'growth': 0.0,
      };
    } catch (e) {
      log('Error getting branch revenue: $e');
      return {};
    }
  }

  @override
  Future<List<ChartData>> getBranchRevenueChartData(String id, {Map<String, dynamic>? filterParams}) async {
    // Tidak ada endpoint spesifik di Postman collection, jadi menggunakan mock data untuk sementara
    try {
      final response = await _apiService.get('/branch/chart/$id', queryParams: filterParams);

      if (response is List) {
        return response.map((item) => ChartData.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ChartData.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting chart data: $e');
      return [];
    }
  }

  @override
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id, {Map<String, dynamic>? filterParams}) async {
    // Tidak ada endpoint spesifik di Postman collection, jadi menggunakan mock data untuk sementara
    try {
      final response = await _apiService.get('/branch/revenue-expense/$id', queryParams: filterParams);

      if (response is List) {
        return response.map((item) => RevenueExpenseData.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => RevenueExpenseData.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting revenue expense data: $e');
      return [];
    }
  }
}

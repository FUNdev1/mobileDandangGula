import 'dart:developer';
import 'package:get/get.dart';
import '../models/branch_model.dart';
import '../services/api_service.dart';

abstract class BranchRepository {
  // Observable collections
  RxList<Branch> get branches;

  // CRUD operations
  Future<Map<String, dynamic>> fetchAllBranches();
  Future<Branch?> getBranchById(String id);
  Future<Map<String, dynamic>> createBranch(Branch branch, {String? photoPath});
  Future<Map<String, dynamic>> updateBranch(Branch branch, {String? photoPath});
  Future<Map<String, dynamic>> deleteBranch(String id);

  // Pagination support
  Future<Map<String, dynamic>> getBranchesPage({int page = 1, int pageSize = 10, String search = ''});
}

class BranchRepositoryImpl implements BranchRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  final RxList<Branch> branches = <Branch>[].obs;

  @override
  Future<Map<String, dynamic>> fetchAllBranches() async {
    try {
      final response = await _apiService.get('/branch/lists');

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        if (response['data'] is List) {
          branches.value = (response['data'] as List).map((item) => Branch.fromJson(item)).toList();
        }
        return response;
      } else if (response is List) {
        branches.value = response.map((item) => Branch.fromJson(item)).toList();
        return {'success': true, 'message': 'OK', 'data': response};
      }

      return {'success': false, 'message': 'Invalid response format', 'data': []};
    } catch (e) {
      log('Error fetching branches: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  @override
  Future<Branch?> getBranchById(String id) async {
    // First, check local cache
    try {
      return branches.firstWhere((branch) => branch.id == id);
    } catch (_) {
      // If not found in local cache, try fetch from API
      try {
        final response = await _apiService.get('/branch/detail/$id');
        if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
          return Branch.fromJson(response['data']);
        }
        return null;
      } catch (e) {
        log('Error fetching branch detail: $e');
        return null;
      }
    }
  }

  @override
  Future<Map<String, dynamic>> createBranch(Branch branch, {String? photoPath}) async {
    try {
      final Map<String, dynamic> data = {
        'kode': branch.code,
        'name': branch.name,
        'address': branch.address ?? '',
        'status': branch.status,
      };

      if (photoPath != null) {
        data['photo'] = photoPath;
      }

      final response = await _apiService.post('/branch/create', body: data);

      if (response['success'] == true) {
        await fetchAllBranches(); // Refresh list
      }

      return response;
    } catch (e) {
      log('Error creating branch: $e');
      return {'success': false, 'message': 'Failed to create branch: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateBranch(Branch branch, {String? photoPath}) async {
    try {
      final Map<String, dynamic> data = {
        'kode': branch.code,
        'name': branch.name,
        'address': branch.address ?? '',
        'status': branch.status,
      };

      if (photoPath != null) {
        data['photo'] = photoPath;
      }

      final response = await _apiService.post('/branch/update/${branch.id}', body: data);

      if (response['success'] == true) {
        // Update local cache
        final index = branches.indexWhere((b) => b.id == branch.id);
        if (index != -1) {
          branches[index] = branch;
          branches.refresh();
        } else {
          await fetchAllBranches(); // If not found, refresh the whole list
        }
      }

      return response;
    } catch (e) {
      log('Error updating branch: $e');
      return {'success': false, 'message': 'Failed to update branch: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteBranch(String id) async {
    try {
      final response = await _apiService.delete('/branch/delete/$id');

      if (response['success'] == true) {
        // Remove from local cache
        branches.removeWhere((branch) => branch.id == id);
        branches.refresh();
      }

      return response;
    } catch (e) {
      log('Error deleting branch: $e');
      return {'success': false, 'message': 'Failed to delete branch: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> getBranchesPage({int page = 1, int pageSize = 10, String search = ''}) async {
    try {
      final response = await _apiService.post('/branch', body: {
        'page': page,
        'pageSize': pageSize,
        'search': search,
      });

      return response;
    } catch (e) {
      log('Error fetching branches page: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }
}

import 'dart:developer';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

abstract class UserRepository {
  // Roles
  Future<List<Role>> getAllRoles();

  // CRUD Operations
  Future<Map<String, dynamic>> getUsersPage({
    required int page,
    int pageSize = 10,
    String search = '',
    String? roleId,
    String? branchId,
  });

  Future<User?> getUserDetail(String id);
  Future<User?> getCurrentUserProfile();

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData, {String? photoPath});
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> userData, {String? photoPath});
  Future<Map<String, dynamic>> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<List<Role>> getAllRoles() async {
    try {
      final response = await _apiService.get('/account/roles');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((role) {
          return Role.fromJson(role);
        }).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching roles: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getUsersPage({
    required int page,
    int pageSize = 10,
    String search = '',
    String? roleId,
    String? branchId,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'pageSize': pageSize,
        'search': search,
      };

      if (roleId != null && roleId.isNotEmpty) {
        requestData['role'] = roleId;
      }

      if (branchId != null && branchId.isNotEmpty) {
        requestData['branch'] = branchId;
      }

      final response = await _apiService.post('/account', body: requestData);
      return response;
    } catch (e) {
      log('Error fetching users page: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  @override
  Future<User?> getUserDetail(String id) async {
    try {
      // This endpoint is not defined in the API Postman collection
      // For a real implementation, we would add it or use a workaround
      final response = await _apiService.get('/account/detail/$id');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return User.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      log('Error fetching user detail: $e');
      return null;
    }
  }

  @override
  Future<User?> getCurrentUserProfile() async {
    try {
      final response = await _apiService.get('/account/profile');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return User.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      log('Error fetching current user profile: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData, {String? photoPath}) async {
    try {
      final Map<String, dynamic> requestData = Map<String, dynamic>.from(userData);

      // Required fields validation
      if (!requestData.containsKey('name') || !requestData.containsKey('username') || !requestData.containsKey('password') || !requestData.containsKey('pin') || !requestData.containsKey('role')) {
        return {
          'success': false,
          'message': 'Missing required fields',
        };
      }

      final response = await _apiService.postWithFile(
        '/account/create',
        photoPath,
        fields: requestData,
      );
      return response;
    } catch (e) {
      log('Error creating user: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> userData, {String? photoPath}) async {
    try {
      if (id.isEmpty) {
        return {'success': false, 'message': 'User ID cannot be empty'};
      }

      final Map<String, dynamic> requestData = Map<String, dynamic>.from(userData);

      if (photoPath != null) {
        requestData['photo'] = photoPath;
      }

      final response = await _apiService.post('/account/update/$id', body: requestData);
      return response;
    } catch (e) {
      log('Error updating user: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteUser(String id) async {
    try {
      if (id.isEmpty) {
        return {'success': false, 'message': 'User ID cannot be empty'};
      }

      final response = await _apiService.delete('/account/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting user: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}

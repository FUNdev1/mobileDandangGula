import 'dart:developer';
import 'package:get/get.dart';
import '../../global_widgets/buttons/app_pagination.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Get paginated and filtered users
  Future<Map<String, dynamic>> getUsers({
    required int page,
    int limit = 8,
    String searchQuery = '',
    String? roleId,
    String? branchId,
  }) async {
    try {
      final response = await _apiService.post('/account', body: {
        'page': page,
        'pageSize': limit,
        'search': searchQuery,
        if (roleId != null) 'role': roleId,
        if (branchId != null) 'branch': branchId,
      });
      if (response is Map<String, dynamic>) {
        return response;
      }
      return {'success': false, 'message': 'Invalid response format', 'data': []};
    } catch (e) {
      log('Error fetching users: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  // Get profile of current user
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get('/account/profile');

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {'success': false, 'message': 'Invalid response format'};
    } catch (e) {
      log('Error fetching user profile: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Add a new user with photo
  Future<Map<String, dynamic>> addUser(Map<String, dynamic> userData, {String? photoPath}) async {
    try {
      // Verifikasi data wajib
      if (userData['name'] == null || userData['username'] == null || userData['password'] == null || userData['pin'] == null || userData['role'] == null) {
        return {'success': false, 'message': 'Missing required fields'};
      }

      Map<String, dynamic> dataToSend = Map<String, dynamic>.from(userData);

      dataToSend['photo'] = photoPath ?? "";
      log('Adding photo path to request: $photoPath');

      final response = await _apiService.post(
        '/account/create',
        body: dataToSend,
      );

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {'success': false, 'message': 'Invalid response format'};
    } catch (e) {
      log('Error adding user: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update existing user with photo
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> userData, {String? photoPath}) async {
    try {
      if (id.isEmpty) {
        return {'success': false, 'message': 'User ID cannot be empty'};
      }

      // Siapkan data yang akan dikirim
      Map<String, dynamic> dataToSend = Map<String, dynamic>.from(userData);

      if (photoPath != null && photoPath.isNotEmpty) {
        dataToSend['photo'] = photoPath;
        log('Adding photo path to update request: $photoPath');
      }

      final response = await _apiService.post('/account/update/$id', body: dataToSend);

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {'success': false, 'message': 'Invalid response format'};
    } catch (e) {
      log('Error updating user: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Delete user
  Future<Map<String, dynamic>> deleteUser(String id) async {
    try {
      final response = await _apiService.delete('/account/delete/$id');

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {'success': true, 'message': 'User deleted successfully'};
    } catch (e) {
      log('Error deleting user: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get available roles for filtering
  Future<Map<String, dynamic>> getRoles() async {
    try {
      final response = await _apiService.get('/account/roles');
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {'success': false, 'message': 'Invalid response format', 'data': []};
    } catch (e) {
      log('Error fetching roles: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }
}

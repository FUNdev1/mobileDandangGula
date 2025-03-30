import 'dart:developer';
import 'package:get/get.dart';
import '../../global_widgets/buttons/app_pagination.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Get paginated and filtered users
  Future<PaginatedResponse<User>> getUsers({
    required int page,
    required int limit,
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

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        final List<User> users = (response['data'] as List).map((item) => User.fromJson(item)).toList();

        return PaginatedResponse<User>(
          data: users,
          page: response['current_page'] ?? page,
          limit: limit,
          total: response['total'] ?? users.length,
          totalPages: response['last_page'] ?? 1,
        );
      }

      // Fallback jika format response tidak sesuai
      return PaginatedResponse<User>(
        data: [],
        page: page,
        limit: limit,
        total: 0,
        totalPages: 1,
      );
    } catch (e) {
      log('Error fetching users: $e');
      return PaginatedResponse<User>(
        data: [],
        page: page,
        limit: limit,
        total: 0,
        totalPages: 1,
      );
    }
  }

  // Get a single user by ID
  Future<User?> getUserById(int id) async {
    try {
      final response = await _apiService.get('/account/detail/$id');
      if (response != null) {
        return User.fromJson(response.cast<String, dynamic>());
      }
      return null;
    } catch (e) {
      log('Error fetching user by ID: $e');
      return null;
    }
  }

  // Add a new user
  Future<User> addUser(User user) async {
    try {
      // Prepare data for API
      final data = {
        'name': user.name,
        'username': user.username,
        'password': user.password, // Pastikan password disediakan
        'pin': user.pin, // Pastikan PIN disediakan
        'role': user.role,
        'status': 'Active',
      };

      // Add photo if available
      if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
        data['photo'] = user.photoUrl;
      }

      final response = await _apiService.post('/account/create', body: data);

      // Kembalikan user baru dengan ID dari response
      if (response != null && response is Map<String, dynamic>) {
        return User.fromJson(response);
      }

      // Fallback jika response tidak sesuai
      throw Exception('Invalid response format');
    } catch (e) {
      log('Error adding user: $e');
      throw Exception('Failed to add user: $e');
    }
  }

  // Update existing user
  Future<User> updateUser(User user) async {
    try {
      if (user.id == null) {
        throw Exception('User ID cannot be null');
      }

      // Prepare data for API
      final data = {
        'name': user.name,
        'username': user.username,
        'role': user.role,
        'status': 'Active',
      };

      // Add photo if available
      if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
        data['photo'] = user.photoUrl;
      }

      final response = await _apiService.post('/account/update/${user.id}', body: data);

      // Kembalikan user yang telah diupdate
      if (response != null && response is Map<String, dynamic>) {
        return User.fromJson(response);
      }

      // Fallback jika response tidak sesuai
      throw Exception('Invalid response format');
    } catch (e) {
      log('Error updating user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    try {
      await _apiService.delete('/account/delete/$id');
      return true;
    } catch (e) {
      log('Error deleting user: $e');
      return false;
    }
  }

  // Get available roles for filtering
  Future<List<Map<String, dynamic>>> getRoles() async {
    try {
      final response = await _apiService.get('/account/roles');

      if (response is List) {
        return response
            .map((role) => {
                  'id': role['id'],
                  'name': role['name'],
                })
            .toList();
      }

      return [];
    } catch (e) {
      log('Error fetching roles: $e');
      return [];
    }
  }

  // Get distinct branches for filtering
  Future<List<Map<String, dynamic>>> getBranches() async {
    try {
      final response = await _apiService.get('/branch/lists');

      if (response is List) {
        return response
            .map((branch) => {
                  'id': branch['id'],
                  'name': branch['name'],
                })
            .toList();
      }

      return [];
    } catch (e) {
      log('Error fetching branches: $e');
      return [];
    }
  }

  // Get available roles as string list (untuk kompatibilitas)
  List<String> getAvailableRoles() {
    return ['admin', 'kasir', 'gudang', 'pusat', 'branchmanager'];
  }
}

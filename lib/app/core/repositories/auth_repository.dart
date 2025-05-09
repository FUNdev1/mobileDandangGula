import 'dart:developer';
import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'user_repository.dart';

abstract class AuthRepository {
  // Authentication methods
  Future<Map<String, dynamic>> login(
    String username,
    String password, {
    String? kodeBranch,
  });
  Future<Map<String, dynamic>> logout();

  // Authentication state
  RxBool isLoggedIn();
  Rx<User?> getCurrentUser();
  String? getToken();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Reactive state
  final RxBool _isLoggedIn = false.obs;
  final Rx<User?> _currentUser = Rx<User?>(null);

  // Constructor to initialize state
  AuthRepositoryImpl() {
    _init();
  }

  // Initialize authentication state
  void _init() async {
    final token = _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      _isLoggedIn.value = true;

      // Load user data if available
      final userData = _storageService.getUser();
      if (userData != null) {
        _currentUser.value = User.fromJson(userData);
      }
      _fetchCurrentUser();
    }
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password, {String? kodeBranch}) async {
    try {
      final Map<String, dynamic> requestData = {
        'username': username,
        'password': password,
      };
      if (kodeBranch != null) {
        requestData['kode_branch'] = kodeBranch;
      }

      final response = await _apiService.post(
        '/auth/login',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response['success'] == true) {
        // Save token
        final token = response['data']['access_token'];
        await _storageService.saveToken(token);

        // Set token for request selanjutnya
        _apiService.setToken(token);

        // Update state
        _isLoggedIn.value = true;

        // Fetch current user
        await _fetchCurrentUser();
      }

      return response;
    } catch (e) {
      log('Login error: $e');
      return {
        'success': false,
        'message': 'Login gagal: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiService.post('/auth/logout');

      // Reset state regardless of API response
      _isLoggedIn.value = false;
      _currentUser.value = null;

      // Delete local data
      await _storageService.deleteToken();
      await _storageService.deleteUser();

      // Clear API token
      _apiService.setToken(null);

      return response;
    } catch (e) {
      log('Logout error: $e');

      // Still reset local state on error
      _isLoggedIn.value = false;
      _currentUser.value = null;
      await _storageService.deleteToken();
      await _storageService.deleteUser();
      _apiService.setToken(null);

      return {
        'success': true,
        'message': 'Logout berhasil (lokal)',
      };
    } finally {
      Get.find<NavigationController>().currentRoute.value = Routes.DASHBOARD;
    }
  }

  @override
  RxBool isLoggedIn() {
    return _isLoggedIn;
  }

  @override
  Rx<User?> getCurrentUser() {
    return _currentUser;
  }

  @override
  String? getToken() {
    return _storageService.getToken();
  }

  // Private method untuk mengambil data user saat ini
  Future<User?> _fetchCurrentUser() async {
    try {
      final response = await _apiService.get('/account/profile');

      if (response is Map<String, dynamic> && response['success'] == true) {
        final userData = response['data'];

        // Jika user memiliki role_id tapi tidak memiliki data role lengkap
        if (userData['role_id'] != null) {
          // Ambil data role lengkap dari UserRepository
          final userRepo = Get.find<UserRepository>();
          final roles = await userRepo.getAllRoles();

          // Cari role yang sesuai dengan role_id user
          final userRoleId = userData['role_id'];
          final matchingRole = roles.firstWhere(
            (role) => role.id == userRoleId,
            orElse: () => Role(id: userRoleId, role: 'Unknown Role'),
          );

          // Update userData dengan role lengkap
          userData['role_data'] = {
            'id': matchingRole.id,
            'role': matchingRole.role,
          };
        }

        // Simpan data user yang sudah lengkap ke storage
        await _storageService.saveUser(userData);

        final user = User.fromJson(userData);
        _currentUser.value = user;
        return user;
      }

      return null;
    } catch (e) {
      log('Error fetching current user: $e');
      return null;
    }
  }
}

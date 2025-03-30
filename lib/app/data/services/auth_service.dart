import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constant/app_constants.dart';
import '../../routes/app_routes.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthService extends GetxService {
  // Storage keys

  // Observable user state
  final _currentUser = Rxn<User>();
  final _isLoggedIn = false.obs;

  // Shared Preferences instance
  late SharedPreferences _prefs;
  late ApiService _apiService;

  // Getters
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get userRole => _currentUser.value?.role ?? '';

  // Initialize service
  Future<AuthService> init() async {
    _apiService = Get.find<ApiService>();
    await _initPrefs();
    return this;
  }

  // Initialize SharedPreferences and load user data
  Future<void> _initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadUserFromStorage();
    } catch (e) {
      debugPrint('Failed to initialize SharedPreferences: $e');
    }
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserFromStorage() async {
    try {
      final bool isUserLoggedIn = _prefs.getBool(AppConstants.IS_LOGGED_IN_KEY) ?? false;

      if (isUserLoggedIn) {
        final String? token = _prefs.getString(AppConstants.TOKEN_STORAGE_KEY);
        if (token != null && token.isNotEmpty) {
          _apiService.setAuthToken(token);

          final String? userStr = _prefs.getString(AppConstants.USER_STORAGE_KEY);
          if (userStr != null && userStr.isNotEmpty) {
            final Map<String, dynamic> userData = jsonDecode(userStr);
            _currentUser.value = User.fromJson(userData);
            _isLoggedIn.value = true;
          } else {
            // Token ada tapi tidak ada data user, coba fetch profile
            try {
              await fetchUserProfile();
            } catch (e) {
              log('Error fetching user profile: $e');
              await _clearUserData();
            }
          }
        } else {
          await _prefs.setBool(AppConstants.IS_LOGGED_IN_KEY, false);
        }
      }
    } catch (e) {
      log('Error loading user data: $e');
      await _clearUserData();
    }
  }

  // Login dengan API
  Future<bool> login(String username, String password, {String? kodeBranch}) async {
    try {
      final response = await _apiService.post('/auth/login', body: {
        'kode_branch': kodeBranch ?? 'KDGMH', // Default jika tidak disediakan
        'username': username,
        'password': password,
      });

      // Handle response based on the structure from your log
      if (response is Map && response.containsKey('success') && response['success'] == true && response.containsKey('data') && response['data'] is Map && response['data'].containsKey('access_token')) {
        final token = response['data']['access_token'];
        _apiService.setAuthToken(token);

        // Simpan token di SharedPreferences
        await _prefs.setString(AppConstants.TOKEN_STORAGE_KEY, token);
        await _prefs.setBool(AppConstants.IS_LOGGED_IN_KEY, true);

        // Ambil profil user
        await fetchUserProfile();

        return true;
      }

      return false;
    } catch (e) {
      log('Login error: $e');
      return false;
    }
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiService.get('/account/profile');

      if (response != null) {
        final User user = User.fromJson(response);
        _currentUser.value = user;
        _isLoggedIn.value = true;

        // Simpan data user
        await _saveUserToStorage(user);
      } else {
        throw Exception('Failed to fetch user profile: Empty response');
      }
    } catch (e) {
      log('Error fetching user profile: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserToStorage(User user) async {
    try {
      final String userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.USER_STORAGE_KEY, userJson);
    } catch (e) {
      log('Error saving user to SharedPreferences: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  // Clear user data from storage
  Future<void> _clearUserData() async {
    await _prefs.remove(AppConstants.USER_STORAGE_KEY);
    await _prefs.remove(AppConstants.TOKEN_STORAGE_KEY);
    await _prefs.setBool(AppConstants.IS_LOGGED_IN_KEY, false);
    _isLoggedIn.value = false;
    _currentUser.value = null;
  }

  // Logout user
  Future<void> logout() async {
    try {
      // Call logout API endpoint
      await _apiService.post('/auth/logout');
    } catch (e) {
      log('Error during logout API call: $e');
    } finally {
      // Tetap clear data lokal meskipun API call gagal
      await _clearUserData();
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}

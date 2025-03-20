import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  // Storage keys
  static const String USER_STORAGE_KEY = 'user_data';
  static const String IS_LOGGED_IN_KEY = 'is_logged_in';

  // Observable user state
  final _currentUser = Rxn<User>();
  final _isLoggedIn = false.obs;

  // Shared Preferences instance
  late SharedPreferences _prefs;

  // Getters for user information
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get userRole => _currentUser.value?.role ?? '';

  // Initialize service
  Future<AuthService> init() async {
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
      // Check if user is logged in
      final bool isUserLoggedIn = _prefs.getBool(IS_LOGGED_IN_KEY) ?? false;

      if (isUserLoggedIn) {
        final String? userStr = _prefs.getString(USER_STORAGE_KEY);
        if (userStr != null && userStr.isNotEmpty) {
          final Map<String, dynamic> userData = jsonDecode(userStr) as Map<String, dynamic>;
          _currentUser.value = User.fromJson(userData);
          _isLoggedIn.value = true;

          debugPrint('User loaded from SharedPreferences: ${_currentUser.value?.name}');
          debugPrint('User is logged in: ${_isLoggedIn.value}');
        } else {
          // User marked as logged in but no data found
          await _prefs.setBool(IS_LOGGED_IN_KEY, false);
        }
      }
    } catch (e) {
      debugPrint('Error loading user data from SharedPreferences: $e');
      // If there's an error, clear potentially corrupted data
      await _clearUserData();
    }
  }

  // Check if user is authenticated and redirect accordingly
  Future<void> checkAuth() async {
    if (_isLoggedIn.value && _currentUser.value != null) {
      // User is logged in, navigate to dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      // User is not logged in, navigate to login
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Login function that handles different user roles properly
  Future<bool> login(String username, String password, {int? locationId}) async {
    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if credentials match any predefined users
      User? authenticatedUser = _authenticateUser(username, password, locationId);

      if (authenticatedUser != null) {
        // Save user data and login state
        await _saveUserToStorage(authenticatedUser);
        await _prefs.setBool(IS_LOGGED_IN_KEY, true);

        // Update current user and login state
        _currentUser.value = authenticatedUser;
        _isLoggedIn.value = true;

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserToStorage(User user) async {
    try {
      final String userJson = jsonEncode(user.toJson());
      await _prefs.setString(USER_STORAGE_KEY, userJson);
      debugPrint('User saved to SharedPreferences');
    } catch (e) {
      debugPrint('Error saving user to SharedPreferences: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  // Clear user data from storage
  Future<void> _clearUserData() async {
    await _prefs.remove(USER_STORAGE_KEY);
    await _prefs.setBool(IS_LOGGED_IN_KEY, false);
    _isLoggedIn.value = false;
    _currentUser.value = null;
  }

  // Authenticate user based on credentials
  User? _authenticateUser(String username, String password, int? locationId) {
    // In a real app, you would check credentials against your backend API
    // For this example, we'll use hardcoded users for different roles

    // Check locationId if it's for pusat role
    if (locationId != null) {
      // Check if this is pusat user with location ID
      if (username == 'pusat' && password == 'password') {
        return User(
          id: 1001,
          name: 'Martha Elbert',
          username: 'martha@example.com',
          role: 'pusat',
          branchId: locationId,
          branchName: 'Pusat - Admin Kantor Pusat',
          photoUrl: 'https://example.com/martha.jpg',
        );
      }
      return null; // Location ID provided but credentials don't match
    }

    // For other roles without location ID
    switch (username) {
      case 'admin':
        if (password == 'password') {
          return User(
            id: 1002,
            name: 'Joe Heiden',
            username: 'joe@example.com',
            role: 'admin',
            branchId: 0, // Admin can access all branches
            branchName: 'Admin Super User',
            photoUrl: 'https://example.com/joe.jpg',
          );
        }
        break;

      case 'kasir':
        if (password == 'password') {
          return User(
            id: 1003,
            name: 'Jun Aizawa',
            username: 'jun@example.com',
            role: 'kasir',
            branchId: 1,
            branchName: 'Kedai Dandang Gula MT. Haryono',
            photoUrl: 'https://example.com/jun.jpg',
          );
        }
        break;

      case 'gudang':
        if (password == 'password') {
          return User(
            id: 1004,
            name: 'Martha Elbert',
            username: 'martha.gudang@example.com',
            role: 'gudang',
            branchId: 2,
            branchName: 'Kedai Dandang Gula MT. Haryono',
            photoUrl: 'https://example.com/martha.jpg',
          );
        }
        break;

      case 'branchmanager':
        if (password == 'password') {
          return User(
            id: 1005,
            name: 'Joe Manager',
            username: 'joe.manager@example.com',
            role: 'branchmanager',
            branchId: 2,
            branchName: 'Kedai Dandang Gula MT. Haryono',
            photoUrl: 'https://example.com/joe_manager.jpg',
          );
        }
        break;
    }
    return null;
  }

  // Log out the current user
  Future<void> logout() async {
    try {
      await _clearUserData();
      // Navigate to login screen
      Get.offAllNamed('/login');
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Error during logout: $e');
      throw Exception('Failed to log out: $e');
    }
  }
}

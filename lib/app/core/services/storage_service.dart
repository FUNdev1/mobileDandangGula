import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk menyimpan dan mengambil data persisten
class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late SharedPreferences _prefs;

  // Keys
  final String _tokenKey = 'auth_token';
  final String _userKey = 'user_data';

  // Inisialisasi service
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Token management
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<bool> deleteToken() async {
    return await _prefs.remove(_tokenKey);
  }

  // User data management
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    return await _prefs.setString(_userKey, jsonEncode(userData));
  }

  Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString(_userKey);
    if (userStr != null) {
      try {
        return jsonDecode(userStr) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<bool> deleteUser() async {
    return await _prefs.remove(_userKey);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}

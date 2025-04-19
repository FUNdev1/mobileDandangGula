import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/user_repository.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form controllers
  final idLokasiController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Form validation
  final RxString idLokasiError = ''.obs;
  final RxString usernameError = ''.obs;
  final RxString passwordError = ''.obs;

  // UI state
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isMasterAdmin = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    idLokasiController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void toggleMasterAdmin(bool? value) {
    isMasterAdmin.value = value ?? false;

    // Reset ID Lokasi error when toggling
    idLokasiError.value = '';
  }

  bool _validateForm() {
    bool isValid = true;

    // Reset all errors first
    usernameError.value = '';
    passwordError.value = '';
    idLokasiError.value = '';

    // Validate masterAdmin
    if (isMasterAdmin.value && idLokasiController.text.isEmpty) {
      idLokasiError.value = 'ID Lokasi harus diisi';
      isValid = false;
    }

    // Validate username
    if (usernameController.text.isEmpty) {
      usernameError.value = 'Username harus diisi';
      isValid = false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password harus diisi';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password minimal 6 karakter';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    // Reset all error messages first
    usernameError.value = '';
    passwordError.value = '';
    idLokasiError.value = '';

    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final response = await _authService.login(
        usernameController.text,
        passwordController.text,
        kodeBranch: idLokasiController.text.isNotEmpty ? idLokasiController.text : null,
      );

      if (response.containsKey('success') && response['success'] == true) {
        // Login successful
        await _authService.fetchUserProfile();

        // Lanjutkan ke dashboard
        navigateToDashboard();
      } else {
        if (response.containsKey('errors') && response['errors'] is Map) {
          final errors = response['errors'] as Map;

          // Update username error if present
          if (errors.containsKey('username')) {
            usernameError.value = errors['username'].toString();
          }

          // Update password error if present
          if (errors.containsKey('password')) {
            passwordError.value = errors['password'].toString();
          }

          // Update kode_branch error if present
          if (errors.containsKey('kode_branch')) {
            idLokasiError.value = errors['kode_branch'].toString();
          }
        }

        AppSnackBar.error(message: response['message'] ?? 'Login gagal');
      }
    } catch (e) {
      log('Login error exception: $e');
      AppSnackBar.error(message: "Terjadi kesalahan saat proses login");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDashboard() {
    Get.offAllNamed(Routes.DASHBOARD);
  }

  void goToForgotPassword() {
    debugPrint('Forgot password');
    // Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  // For development/testing - prefill login credentials
  void loginAsRole(String role) {
    switch (role) {
      case 'admin':
        usernameController.text = 'marthael';
        passwordController.text = 'marthael';
        isMasterAdmin.value = false;
        break;

      case 'pusat':
        usernameController.text = 'marthael';
        passwordController.text = 'ADMINPUSAT';
        isMasterAdmin.value = true;
        idLokasiController.text = 'KDGMH';
        break;

      case 'kasir':
        usernameController.text = 'kasir';
        passwordController.text = 'kasir123';
        isMasterAdmin.value = false; 
        break;

      case 'gudang':
        usernameController.text = 'gudang';
        passwordController.text = 'password';
        isMasterAdmin.value = false;
        break;

      case 'branchmanager':
        usernameController.text = 'branchmanager';
        passwordController.text = 'password';
        isMasterAdmin.value = false;
        break;
    }

    // Reset error messages when prefilling
    usernameError.value = '';
    passwordError.value = '';
    idLokasiError.value = '';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../routes/app_routes.dart';

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

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void toggleMasterAdmin(bool? value) {
    isMasterAdmin.value = value ?? false;
  }


  bool _validateForm() {
    bool isValid = true;

    // Validate masterAdmin
    if (isMasterAdmin.value && idLokasiController.text.isEmpty) {
      idLokasiError.value = 'ID Lokasi is required';
      isValid = false;
    } else {
      idLokasiError.value = '';
    }

    // Validate username
    if (usernameController.text.isEmpty) {
      usernameError.value = 'Username is required';
      isValid = false;
    } else {
      usernameError.value = '';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final success = await _authService.login(
        usernameController.text,
        passwordController.text,
        locationId: isMasterAdmin.value ? int.tryParse(idLokasiController.text) : null,
      );

      if (success) {
        // Navigate to dashboard (the dashboard will show appropriate view based on role)
        navigateToDashboard();
      } else {
        AppSnackBar.error(
          message: "Invalid username or password",
        );
      }
    } catch (e) {
      AppSnackBar.error(
        message: "An error occurred during login",
      );
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
        usernameController.text = 'admin';
        passwordController.text = 'password';
        isMasterAdmin.value = false;
        break;

      case 'pusat':
        usernameController.text = 'pusat';
        passwordController.text = 'password';
        isMasterAdmin.value = true;
        idLokasiController.text = '1';
        break;

      case 'kasir':
        usernameController.text = 'kasir';
        passwordController.text = 'password';
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
  }
}

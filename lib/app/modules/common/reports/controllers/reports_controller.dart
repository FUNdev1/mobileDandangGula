import 'package:get/get.dart';

import '../../../../data/services/auth_service.dart';

class ReportsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data
  }
  
  @override
  void onReady() {
    super.onReady();
    // Dipanggil setelah widget dirender
  }
  
  @override
  void onClose() {
    // Bersihkan resource
    super.onClose();
  }
}
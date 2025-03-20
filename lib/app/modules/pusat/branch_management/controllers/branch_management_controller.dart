import 'package:get/get.dart';
import '../../../../data/services/auth_service.dart';

class BranchManagementController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  // final MenuRepository _menuRepository = Get.find<MenuRepository>();
  
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
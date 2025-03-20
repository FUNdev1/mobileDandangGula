import 'package:get/get.dart';
import '../../../../data/services/auth_service.dart';
import '../controllers/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure the AuthService is registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }

    Get.lazyPut<SettingController>(() => SettingController());
  }
}

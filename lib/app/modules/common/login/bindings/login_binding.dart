import 'package:get/get.dart';
import '../../../../data/repositories/user_repository.dart';
import '../controllers/login_controller.dart';
import '../../../../data/services/auth_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure the AuthService is registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<UserRepository>()) {
      Get.put(UserRepository());
    }

    Get.lazyPut<LoginController>(() => LoginController());
  }
}

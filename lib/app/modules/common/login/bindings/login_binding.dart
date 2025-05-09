import 'package:dandang_gula/app/core/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../../../core/repositories/user_repository.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure the AuthService is registered
    if (!Get.isRegistered<AuthRepositoryImpl>()) {
      Get.put(AuthRepositoryImpl(), permanent: true);
    }
    if (!Get.isRegistered<UserRepositoryImpl>()) {
      Get.put(UserRepositoryImpl());
    }

    Get.lazyPut<LoginController>(() => LoginController());
  }
}

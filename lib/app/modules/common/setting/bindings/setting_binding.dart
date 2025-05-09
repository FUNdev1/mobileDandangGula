import 'package:dandang_gula/app/core/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
  }
}

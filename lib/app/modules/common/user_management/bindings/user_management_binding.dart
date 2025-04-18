import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';

class UserManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}

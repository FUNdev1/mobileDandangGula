import 'package:get/get.dart';

import 'add_menu_management_controller.dart';

class AddMenuManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMenuController>(() => AddMenuController());
  }
}

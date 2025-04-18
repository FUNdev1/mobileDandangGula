import 'package:get/get.dart';

import '../../../../data/repositories/menu_management_repository.dart';
import '../controllers/menu_management_controller.dart';
import '../component/page/add_menu_management/add_menu_management_controller.dart';

class MenuManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuManagementController>(() => MenuManagementController());
    Get.lazyPut<MenuManagementRepositoryImpl>(() => MenuManagementRepositoryImpl());
  }
}

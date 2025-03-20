import 'package:get/get.dart';

import '../controllers/branch_management_controller.dart';

class BranchManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BranchManagementController>(() => BranchManagementController());
  }
}
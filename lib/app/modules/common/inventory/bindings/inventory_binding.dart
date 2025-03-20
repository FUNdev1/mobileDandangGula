// lib/app/modules/common/inventory/bindings/inventory_binding.dart
import 'package:get/get.dart';
import '../../../../data/repositories/inventory_repository.dart';
import '../controllers/inventory_controller.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure repository is registered
    if (!Get.isRegistered<InventoryRepository>()) {
      Get.put(InventoryRepositoryImpl());
    }

    Get.lazyPut<InventoryController>(() => InventoryController());
  }
}

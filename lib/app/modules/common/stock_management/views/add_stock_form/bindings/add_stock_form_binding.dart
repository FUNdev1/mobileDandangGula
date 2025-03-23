import 'package:get/get.dart';
import '../controllers/add_stock_form_controller.dart';

class AddStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddStockController>(() => AddStockController());
  }
}

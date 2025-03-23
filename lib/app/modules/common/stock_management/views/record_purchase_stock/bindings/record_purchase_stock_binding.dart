import 'package:get/get.dart';
import '../controllers/record_purchase_stock_controller.dart';

class RecordPurchaseStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordPurchaseStockController>(() => RecordPurchaseStockController());
  }
}

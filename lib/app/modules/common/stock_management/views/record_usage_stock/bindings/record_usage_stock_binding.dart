import 'package:get/get.dart';

import '../controllers/record_usage_stock_controller.dart';

class RecordUsageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordUsageController>(() => RecordUsageController());
  }
}

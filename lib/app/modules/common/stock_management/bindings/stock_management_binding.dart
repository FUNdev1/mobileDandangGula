import 'package:get/get.dart';
import '../../../../core/repositories/stock_management_repository.dart';
import '../../dashboard/widgets/filter/period_filter_controller.dart';
import '../controllers/stock_management_controller.dart';

class StockManagementBinding extends Bindings {
  @override
  void dependencies() {
    // Filter Controller
    if (!Get.isRegistered<PeriodFilterController>()) {
      Get.lazyPut<PeriodFilterController>(() => PeriodFilterController());
    }

    // Main controller
    Get.lazyPut<StockManagementController>(() => StockManagementController());
  }
}

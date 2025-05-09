import 'package:dandang_gula/app/core/repositories/auth_repository.dart';
import 'package:dandang_gula/app/core/repositories/cashier_repository.dart';
import 'package:dandang_gula/app/core/repositories/menu_repository.dart';
import 'package:get/get.dart';
import '../../../../core/repositories/branch_repository.dart';
import '../../../../core/repositories/dashboard_repository.dart';
import '../../../../core/repositories/stock_management_repository.dart';
import '../../../../core/repositories/order_repository.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/filter/period_filter_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());

    // Filter Controller
    Get.lazyPut<PeriodFilterController>(() => PeriodFilterController());

    // Dashboard Controller
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

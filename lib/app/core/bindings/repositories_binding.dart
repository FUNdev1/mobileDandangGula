import 'package:dandang_gula/app/core/repositories/dashboard_repository.dart';
import 'package:dandang_gula/app/core/repositories/stock_management_repository.dart';
import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../repositories/branch_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/inventory_repository.dart';
import '../repositories/menu_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/cashier_repository.dart';
import '../repositories/report_repository.dart';

class RepositoriesBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Register all repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<BranchRepository>(() => BranchRepositoryImpl(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(), fenix: true);
    Get.lazyPut<InventoryRepository>(() => InventoryRepositoryImpl(), fenix: true);
    Get.lazyPut<MenuRepository>(() => MenuRepositoryImpl(), fenix: true);
    Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(), fenix: true);
    Get.lazyPut<CashierRepository>(() => CashierRepositoryImpl(), fenix: true);
    Get.lazyPut<ReportRepository>(() => ReportRepositoryImpl(), fenix: true);
    Get.lazyPut<DashboardRepository>(() => DashboardRepositoryImpl(), fenix: true);
    Get.lazyPut<StockManagementRepository>(() => StockManagementRepositoryImpl(), fenix: true);
  }
}

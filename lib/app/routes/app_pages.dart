import 'package:get/get.dart';
import '../core/middleware/auth_middleware.dart';

// Common modules
import '../modules/common/dashboard/views/components/dashboard_view.dart';
import '../modules/common/login/bindings/login_binding.dart';
import '../modules/common/login/views/login_view.dart';
import '../modules/common/dashboard/bindings/dashboard_binding.dart';
import '../modules/common/reports/bindings/reports_binding.dart';
import '../modules/common/reports/views/reports_view.dart';
import '../modules/common/setting/bindings/setting_binding.dart';
import '../modules/common/setting/views/setting_view.dart';

// Admin modules

// Pusat modules
import '../modules/pusat/branch_management/bindings/branch_management_binding.dart';
import '../modules/pusat/branch_management/views/branch_management_view.dart';

// // User management (common)
// import '../modules/common/user_management/bindings/user_management_binding.dart';
// import '../modules/common/user_management/views/user_management_view.dart';

// // Inventory (common)
import '../modules/common/inventory/bindings/inventory_binding.dart';
import '../modules/common/inventory/views/inventory_view.dart';
import '../modules/common/inventory/views/stock_in_view.dart';
import '../modules/common/inventory/views/stock_out_view.dart';

// // Orders (common)
// import '../modules/common/orders/bindings/orders_binding.dart';
// import '../modules/common/orders/views/orders_view.dart';
// import '../modules/common/orders/views/new_order_view.dart';
// import '../modules/common/orders/views/order_details_view.dart';

// // Kasir modules
// import '../modules/kasir/attendance/bindings/attendance_binding.dart';
// import '../modules/kasir/attendance/views/attendance_view.dart';

// // Branch Manager modules
// import '../modules/branch_manager/menu_management/bindings/menu_management_binding.dart';
// import '../modules/branch_manager/menu_management/views/menu_management_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Auth routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    // Common routes
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    GetPage(
      name: Routes.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Pusat routes
    GetPage(
      name: Routes.BRANCH_MANAGEMENT,
      page: () => const BranchManagementView(),
      binding: BranchManagementBinding(),
      // middlewares: [
      //   AuthMiddleware(allowedRoles: ['pusat']),
      // ],
    ),

    // // User management (common)
    // GetPage(
    //   name: Routes.USER_MANAGEMENT,
    //   page: () => const UserManagementView(),
    //   binding: UserManagementBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['admin', 'pusat', 'branchmanager']),
    //   ],
    // ),

    // // Inventory (common)
    GetPage(
      name: Routes.INVENTORY,
      page: () => const InventoryView(),
      binding: InventoryBinding(),
      middlewares: [
        AuthMiddleware(allowedRoles: ['gudang', 'branchmanager']),
      ],
    ),
    GetPage(
      name: Routes.STOCK_IN,
      page: () => const StockInView(),
      binding: InventoryBinding(),
      middlewares: [
        AuthMiddleware(allowedRoles: ['gudang', 'branchmanager']),
      ],
    ),
    GetPage(
      name: Routes.STOCK_OUT,
      page: () => const StockOutView(),
      binding: InventoryBinding(),
      middlewares: [
        AuthMiddleware(allowedRoles: ['gudang', 'branchmanager']),
      ],
    ),

    // // Orders (common)
    // GetPage(
    //   name: Routes.ORDERS,
    //   page: () => const OrdersView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'branchmanager']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.NEW_ORDER,
    //   page: () => const NewOrderView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'branchmanager']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.ORDER_DETAILS,
    //   page: () => const OrderDetailsView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'branchmanager']),
    //   ],
    // ),

    // // Attendance (kasir)
    // GetPage(
    //   name: Routes.ATTENDANCE,
    //   page: () => const AttendanceView(),
    //   binding: AttendanceBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir']),
    //   ],
    // ),

    // // Menu management (branch manager)
    // GetPage(
    //   name: Routes.MENU_MANAGEMENT,
    //   page: () => const MenuManagementView(),
    //   binding: MenuManagementBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['branchmanager']),
    //   ],
    // ),
  ];

  static const initialRoute = Routes.LOGIN;
}

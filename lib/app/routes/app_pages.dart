import 'package:dandang_gula/app/modules/common/stock_management/bindings/stock_management_binding.dart';
import 'package:dandang_gula/app/modules/common/stock_management/views/stock_management_view.dart';
import 'package:dandang_gula/app/modules/common/user_management/bindings/user_management_binding.dart';
import 'package:dandang_gula/app/modules/common/user_management/views/user_management_view.dart';
import 'package:get/get.dart';
import '../core/middleware/auth_middleware.dart';

// Common modules
import '../modules/common/dashboard/views/components/dashboard_view.dart';
import '../modules/common/login/bindings/login_binding.dart';
import '../modules/common/login/views/login_view.dart';
import '../modules/common/dashboard/bindings/dashboard_binding.dart';
import '../modules/common/menu_management/bindings/menu_management_binding.dart';
import '../modules/common/menu_management/views/menu_management_view.dart';
import '../modules/common/reports/bindings/reports_binding.dart';
import '../modules/common/reports/views/reports_view.dart';
import '../modules/common/setting/bindings/setting_binding.dart';
import '../modules/common/setting/pages/pengaturan_akun_tab_pages.dart';
import '../modules/common/setting/views/setting_view.dart';

// Admin modules

// Pusat modules
import '../modules/common/stock_management/views/add_stock_form/bindings/add_stock_form_binding.dart';
import '../modules/common/stock_management/views/add_stock_form/views/add_stock_form_view.dart';
import '../modules/pusat/branch_management/bindings/branch_management_binding.dart';
import '../modules/pusat/branch_management/views/branch_management_view.dart';

// // User management (common)
// import '../modules/common/user_management/bindings/user_management_binding.dart';
// import '../modules/common/user_management/views/user_management_view.dart';

// // Orders (common)
// import '../modules/common/orders/bindings/orders_binding.dart';
// import '../modules/common/orders/views/orders_view.dart';
// import '../modules/common/orders/views/new_order_view.dart';
// import '../modules/common/orders/views/order_details_view.dart';

// // Kasir modules
// import '../modules/kasir/attendance/bindings/attendance_binding.dart';
// import '../modules/kasir/attendance/views/attendance_view.dart';

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
      name: Routes.USER_MANAGEMENT, // Pengaturan Akun/Managemen User
      page: () => const UserManagementView(),
      binding: UserManagementBinding(),
      // middlewares: [AuthMiddleware()],
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
    //     AuthMiddleware(allowedRoles: ['admin', 'pusat', 'supervisor']),
    //   ],
    // ),

    // // Inventory (common)
    GetPage(
      name: Routes.STOCK_MANAGEMENT,
      page: () => const StockManagementView(),
      binding: StockManagementBinding(),
      middlewares: [
        AuthMiddleware(allowedRoles: ['gudang', 'supervisor', 'admin']),
      ],
    ),
    GetPage(
      name: Routes.STOCK_MANAGEMENT_ADD,
      page: () => const AddStockForm(),
      binding: AddStockBinding(),
      middlewares: [
        AuthMiddleware(allowedRoles: ['gudang', 'supervisor', 'admin']),
      ],
    ),

    GetPage(
      name: Routes.STOCK_MANAGEMENT_EDIT,
      page: () => const AddStockForm(isEdit: true),
      binding: AddStockBinding(),
    ),

    // // Orders (common)
    // GetPage(
    //   name: Routes.ORDERS,
    //   page: () => const OrdersView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'supervisor']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.NEW_ORDER,
    //   page: () => const NewOrderView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'supervisor']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.ORDER_DETAILS,
    //   page: () => const OrderDetailsView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'supervisor']),
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

    // Menu management (branch manager)
    GetPage(
      name: Routes.MENU_MANAGEMENT,
      page: () => const MenuManagementView(),
      binding: MenuManagementBinding(),
      middlewares: [
        AuthMiddleware(allowedRoles: ['supervisor']),
      ],
    ),
  ];

  static const initialRoute = Routes.LOGIN;
}

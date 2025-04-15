abstract class Routes {
  // Auth routes
  static const LOGIN = '/login';
  
  // Common routes
  static const DASHBOARD = '/dashboard';
  static const REPORTS = '/reports';
  static const PROFILE = '/profile';
  static const NOTIFICATIONS = '/notifications';
  static const SETTING = '/settings';
  
  // Branch management (admin & pusat)
  static const BRANCH_MANAGEMENT = '/branch-management';
  
  // User management (admin, pusat & branch manager)
  static const USER_MANAGEMENT = '/user-management';
  
  // Stock Management (gudang & branch manager & admin)
  static const STOCK_MANAGEMENT = '/stock_management';
  static const STOCK_MANAGEMENT_ADD = '/stock_management/add-stock';
  static const STOCK_MANAGEMENT_EDIT = '/stock_management/edit-stock';
  
  // static const INVENTORY = '/inventory';
  // static const STOCK_IN = '/inventory/stock-in';
  // static const STOCK_OUT = '/inventory/stock-out';
  
  // Orders (kasir & branch manager)
  static const ORDERS = '/orders';
  static const NEW_ORDER = '/orders/new';
  static const ORDER_DETAILS = '/orders/details';
  
  // Attendance (kasir)
  static const ATTENDANCE = '/attendance';
  
  // Menu management (branch manager only)
  static const MENU_MANAGEMENT = '/menu-management';
  static const ADD_MENU_MANAGEMENT = '/menu-management/add';
  static const MENU_MANAGEMENT_CATEGORY = '/menu-management/category';
}
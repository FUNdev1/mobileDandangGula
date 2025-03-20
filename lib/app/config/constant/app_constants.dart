class AppConstants {
  // API constants
  static const String baseUrl = 'https://api.dandanggula.com/v1';
  
  // Feature flags
  static const bool enableReports = true;
  static const bool enableUserManagement = true;
  static const bool enableInventory = true;
  
  // App Info
  static const String appName = 'Dandang Gula';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  
  // Timeouts
  static const int connectionTimeout = 30; // in seconds
  static const int receiveTimeout = 30; // in seconds
  
  // Paging defaults
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
}

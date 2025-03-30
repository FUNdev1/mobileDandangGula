import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/config/constant/app_constants.dart';
import 'app/config/theme/app_theme.dart';
import 'app/core/controllers/navigation_controller.dart';
import 'app/data/services/api_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Force landscape orientation for tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  Get.put(ApiService(baseUrl: AppConstants.baseUrl));
  final authService = await Get.putAsync(() => AuthService().init());

  Get.put(NavigationController(), permanent: true);
  final initialRoute = authService.isLoggedIn ? Routes.DASHBOARD : Routes.LOGIN;

  runApp(
    GetMaterialApp(
      title: "Dandang Gula",
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({
    super.key,
    required this.authService,
  });
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dandang Gula Restaurant Management',
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.noTransition,
      initialRoute: _getInitialRoute(),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    // Check if user is logged in and determine the appropriate route
    if (authService.isLoggedIn) {
      return Routes.DASHBOARD;
    } else {
      return Routes.LOGIN;
    }
  }
}

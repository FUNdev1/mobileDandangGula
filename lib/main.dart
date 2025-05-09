import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/repositories/auth_repository.dart';
import 'app/core/utils/constant/app_constants.dart';
import 'app/core/utils/theme/app_theme.dart';
import 'app/core/controllers/navigation_controller.dart';
import 'app/core/bindings/repositories_binding.dart';
import 'app/core/services/api_service.dart';
import 'app/routes/app_pages.dart';
import 'app/core/bindings/service_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Force landscape orientation for tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await ServiceBinding().dependencies();

  await RepositoriesBinding().dependencies();

  Get.put(NavigationController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
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
    // Mendapatkan AuthRepository dari GetX dependency injection
    final authRepository = Get.find<AuthRepository>();

    // Check if user is logged in and determine the appropriate route
    if (authRepository.isLoggedIn().value) {
      return Routes.DASHBOARD;
    } else {
      return Routes.LOGIN;
    }
  }
}

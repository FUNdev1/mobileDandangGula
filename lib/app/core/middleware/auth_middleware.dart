// lib/app/core/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final List<String>? allowedRoles;

  AuthMiddleware({this.allowedRoles});

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    // Jika rute adalah splash atau login, tidak perlu cek auth
    if (route == Routes.LOGIN) {
      return null;
    }

    // Cek apakah user sudah login
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    // Jika allowedRoles tidak null, cek apakah role user sesuai
    if (allowedRoles != null && !allowedRoles!.contains(authService.userRole)) {
      // Redirect ke dashboard jika tidak memiliki akses
      return const RouteSettings(name: Routes.DASHBOARD);
    }

    // Lanjutkan ke route yang diminta jika semua pengecekan lolos
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }
}

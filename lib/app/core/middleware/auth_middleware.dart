import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final List<String>? allowedRoles;

  AuthMiddleware({this.allowedRoles});

  @override
  RouteSettings? redirect(String? route) {
    final authRepository = Get.find<AuthRepository>();

    // Jika rute adalah login, tidak perlu cek auth
    if (route == Routes.LOGIN) {
      return null;
    }

    // Cek apakah user sudah login
    if (!authRepository.isLoggedIn().value) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    // Jika allowedRoles tidak null, ambil data user saat ini dan cek rolenya
    if (allowedRoles != null) {
      final currentUser = authRepository.getCurrentUser().value;

      if (currentUser == null || currentUser.role == null || !allowedRoles!.contains(currentUser.role!.role.toLowerCase())) {
        // Redirect ke dashboard jika tidak memiliki akses
        return const RouteSettings(name: Routes.DASHBOARD);
      }
    }

    // Lanjutkan ke route yang diminta jika semua pengecekan lolos
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }
}

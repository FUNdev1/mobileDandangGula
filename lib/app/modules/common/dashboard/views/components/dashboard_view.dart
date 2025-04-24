import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global_widgets/layout/app_layout.dart';
import '../../controllers/dashboard_controller.dart';
import '../admin_view.dart';
import '../branch_manager_view.dart';
import '../gudang_view.dart';
import '../kasir_view.dart';
import '../pusat_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan factory pattern untuk mendapatkan controller yang sesuai
    final dashboardController = DashboardController.to;

    return Obx(() {
      if (dashboardController.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Untuk role lainnya, gunakan AppLayout dengan content yang sesuai
      Widget dashboardContent;
      switch (dashboardController.userRole.value) {
        case 'admin':
          dashboardContent = AdminDashboardView();
          break;
        case 'pusat':
          dashboardContent = PusatDashboardView();
          break;
        case 'supervisor':
          dashboardContent = BranchManagerDashboardView();
          break;
        case 'gudang':
          dashboardContent = GudangDashboardView();
          break;
        case 'kasir':
          dashboardContent = KasirDashboardView();
          break;
        default:
          dashboardContent = Center(
            child: Text('Role tidak valid: ${dashboardController.userRole.value}'),
          );
      }

      // Wrap with AppLayout
      final args = Get.arguments as Map<String, dynamic>? ?? {};
      final refreshKey = args['refreshKey'] ?? 0;

      return AppLayout(
        key: ValueKey('dashboard_$refreshKey'),
        content: dashboardContent,
        onRefresh: () async {
          await dashboardController.initializeController();
        },
      );
    });
  }
}

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
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Kasir view memiliki layout khusus
      // if (controller.userRole.value == 'kasir') {
      //   return KasirDashboardView(controller: controller);
      // }

      // Untuk role lainnya, gunakan AppLayout dengan content yang sesuai
      Widget dashboardContent;
      switch (controller.userRole.value) {
        case 'admin':
          dashboardContent = const AdminDashboardView();
          break;
        case 'pusat':
          dashboardContent = PusatDashboardView(controller: controller);
          break;
        case 'branchmanager':
          dashboardContent = BranchManagerDashboardView(controller: controller);
          break;
        case 'gudang':
          dashboardContent = GudangDashboardView(controller: controller);
          break;
        case 'kasir':
          dashboardContent = KasirDashboardView(controller: controller);
          break;
        default:
          dashboardContent = Center(
            child: Text('Role tidak valid: ${controller.userRole.value}'),
          );
      }

      // Wrap with AppLayout
      return AppLayout(
        content: dashboardContent,
        onRefresh: () async {
          await controller.initializeData();
        },
      );
    });
  }
}

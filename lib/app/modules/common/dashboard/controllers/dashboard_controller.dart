import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/models/category_sales_model.dart';
import '../../../../data/models/chart_data_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../data/models/product_sales_model.dart';
import '../../../../data/models/stock_alert_model.dart';
import '../../../../data/models/stock_flow_data_model.dart';
import '../../../../data/models/stock_usage_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/branch_repository.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../data/repositories/stock_management_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/services/auth_service.dart';
import '../widgets/filter/period_filter_controller.dart';
import 'admin_dashboard_controller.dart';
import 'pusat_dashboard_controller.dart';
import 'supervisor_dashboard_controller.dart';
import 'kasir_dashboard_controller.dart';
import 'gudang_dashboard_controller.dart';
import 'base_dashboard_controller.dart';

class DashboardController extends BaseDashboardController {
  static BaseDashboardController get to {
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }

    final controller = Get.find<DashboardController>();
    final role = controller.userRole.value;

    // Return role-specific controller
    switch (role) {
      case 'admin':
        if (!Get.isRegistered<AdminDashboardController>()) {
          Get.put(AdminDashboardController(), permanent: true);
        }
        return Get.find<AdminDashboardController>();
      case 'pusat':
        if (!Get.isRegistered<PusatDashboardController>()) {
          Get.put(PusatDashboardController(), permanent: true);
        }
        return Get.find<PusatDashboardController>();
      case 'supervisor':
        if (!Get.isRegistered<SupervisorDashboardController>()) {
          Get.put(SupervisorDashboardController(), permanent: true);
        }
        return Get.find<SupervisorDashboardController>();
      case 'kasir':
        if (!Get.isRegistered<KasirDashboardController>()) {
          Get.put(KasirDashboardController(), permanent: true);
        }
        return Get.find<KasirDashboardController>();
      case 'gudang':
        if (!Get.isRegistered<GudangDashboardController>()) {
          Get.put(GudangDashboardController(), permanent: true);
        }
        return Get.find<GudangDashboardController>();
      default:
        return controller;
    }
  }

  @override
  Future<void> loadDashboardData() async {
    // Implementasi dasar jika tidak ada controller spesifik
    try {
      final filterParams = periodFilterController.getFilterParams();

      // Dapatkan data dasar dashboard
      final summary = await dashboardRepository.fetchDashboardSummary(filterParams: filterParams);
      todaySales.value = summary.totalIncome;
      todayProfit.value = summary.netProfit;
      salesGrowth.value = summary.percentChange;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading dashboard data: $e');
      }
    }
  }
}

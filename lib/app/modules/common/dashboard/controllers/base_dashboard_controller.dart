import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/branch_repository.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../data/repositories/stock_management_repository.dart';
import '../../../../data/services/auth_service.dart';
import '../widgets/filter/period_filter_controller.dart';

abstract class BaseDashboardController extends GetxController {
  // Repositories
  final BranchRepository branchRepository = Get.find<BranchRepository>();
  final DashboardRepository dashboardRepository = Get.find<DashboardRepository>();
  final OrderRepository orderRepository = Get.find<OrderRepository>();
  final StockManagementRepository stockRepository = Get.find<StockManagementRepository>();
  final AuthService authService = Get.find<AuthService>();

  // Observable variables
  final isLoading = true.obs;
  final userRole = ''.obs;
  final selectedBranchId = ''.obs;
  final todaySales = 0.0.obs;
  final todayProfit = 0.0.obs;
  final salesGrowth = 0.0.obs;
  
  // Period filter controller
  final periodFilterController = Get.find<PeriodFilterController>();

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  Future<void> initializeController() async {
    try {
      isLoading.value = true;
      
      // Get user role
      final user = authService.currentUser;
      userRole.value = user?.roleName ?? '';
      
      // Initialize period filter
      // periodFilterController.initialize();
      
      // Load initial data
      await fetchInitialData();
      
      // Load dashboard data
      await loadDashboardData();
      
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing dashboard: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> fetchInitialData() async {
    try {
      // Fetch branches
      await branchRepository.fetchAllBranches();
      
      // Set default branch if available
      if (branchRepository.branches.isNotEmpty) {
        selectedBranchId.value = branchRepository.branches.first.id;
      }
    } catch (e) {
      log('Error in fetchInitialData: $e');
    }
  }
  
  // Select a branch
  void selectBranch(String branchId) {
    selectedBranchId.value = branchId;
    loadDashboardData();
  }
  
  // Period filter changed
  void onPeriodFilterChanged(String periodId) {
    loadDashboardData();
  }
  
  // Abstract method to be implemented by subclasses
  Future<void> loadDashboardData();
}
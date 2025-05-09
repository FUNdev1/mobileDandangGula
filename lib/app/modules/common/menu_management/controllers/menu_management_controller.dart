import 'dart:io';
import 'package:dandang_gula/app/core/models/menu_model.dart';
import 'package:dandang_gula/app/core/repositories/auth_repository.dart';
import 'package:dandang_gula/app/core/repositories/menu_repository.dart';
import 'package:dandang_gula/app/core/repositories/order_repository.dart';
import 'package:dandang_gula/app/core/repositories/stock_management_repository.dart';
import 'package:get/get.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../core/repositories/branch_repository.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/api_service.dart';
import 'package:flutter/material.dart';

import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../routes/app_routes.dart';
import '../component/page/add_menu_management/add_menu_management_view.dart';
import '../component/page/menu_management_detail/menu_management_detail_view.dart';

class MenuManagementController extends GetxController {
  // Repository
  final menuManagementRepository = Get.find<MenuRepositoryImpl>();

  // Observable variables
  final isLoading = false.obs;
  final users = <User>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalData = RxnInt();
  final itemsPerPage = 8.obs;
  final RxList<dynamic> categories = <dynamic>[].obs;
  final selectedCategory = RxnString();

  // Branch related variables
  final branches = [].obs;
  final selectedBranchId = RxnString();
  final isAdminPusat = false.obs;

  // Role filter variables
  final selectedRoleFilter = RxnString();
  final sortColumn = RxString('');
  final sortAscending = RxBool(true);

  // Text controllers
  final selectedUser = Rxn<User?>();
  final searchController = TextEditingController();
  final menuList = <Menu>[].obs;

  final authService = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    // Check if user has AdminPusat role
    fetchData(firstTime: true);
  }

  void loadBranches() async {
    try {
      final repository = BranchRepositoryImpl();
      final response = await repository.fetchAllBranches();

      if (response['success'] == true) {
        branches.value = response['data'];
      } else {
        AppSnackBar.error(message: 'Failed to load branches: ${response['message']}');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load branches: $e');
    }
  }

  void fetchData({bool firstTime = false}) {
    loadRolesAndUsers(firstTime: firstTime);
  }

  void loadRolesAndUsers({bool firstTime = false}) async {
    isLoading.value = true;
    try {
      // First load categories
      final categoriesResponse = await menuManagementRepository.getAllCategories();
      if (categoriesResponse.isNotEmpty) {
        // Sengaja tidak pakai object, untuk kebutuhan dropwdon map<string,dynamic>
        categories.value = categoriesResponse.map((e) => e.toJson()).toList();
        selectedCategory.value ??= '';
      }

      // Then load menu list
      final menuResponse = await menuManagementRepository.getMenuPage(
        page: currentPage.value,
        categoryId: selectedCategory.value ?? "",
        search: searchController.text,
        pageSize: itemsPerPage.value,
      );
      if (menuResponse.isNotEmpty && menuResponse["data"] is List) {
        List menu = menuResponse["data"];
        menuList.value = menu.map((e) => Menu.fromJson(e)).toList();
        totalPages.value = menuResponse["total_page"] ?? 0;
        currentPage.value = menuResponse["page"] ?? 1;
        totalData.value = menuResponse["total_data"] ?? 0;

        menuList.refresh();
        // Set selectedRoleFilter if it's the first time loading
        if (firstTime && menuList.isNotEmpty) {
          selectedRoleFilter.value = menuList[0].id;
        }
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchMenu() {
    currentPage.value = 1;
    loadRolesAndUsers();
  }

  void goToPage(int page) {
    if (page != currentPage.value) {
      currentPage.value = page;
      loadRolesAndUsers();
    }
  }

  void openAddMenu() {
    Get.toNamed(Routes.ADD_MENU_MANAGEMENT)?.then((result) => loadRolesAndUsers());
  }

  void openManajemenKategori() {
    Get.toNamed(Routes.MENU_MANAGEMENT_CATEGORY)?.then((_) => loadRolesAndUsers());
  }

  void openMenuDetail(String menuId) async {
    try {
      final response = await menuManagementRepository.getMenuDetail(menuId);

      final menuData = response;
      // Show menu detail dialog
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: MenuDetailDialog(menu: menuData),
        ),
      );
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    }
  }

  void editMenu(String menuId) async {
    isLoading.value = true;
    try {
      final response = await menuManagementRepository.getMenuDetail(menuId);

      final menuData = response;
      // Open edit menu dialog
      // Get.dialog(
      //   Dialog(
      //     insetPadding: EdgeInsets.zero,
      //     backgroundColor: Colors.transparent,
      //     child: EditMenuDialog(menuController: this, menuData: menuData),
      //   ),
      //   barrierDismissible: false,
      // ).then((result) {
      //   if (result == true) {
      //     // Refresh menu list if a menu was edited
      //     loadRolesAndUsers();
      //   }
      // });
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteMenu(String menuId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Menu?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Menu yang dihapus tidak dapat dikembalikan. Yakin ingin menghapus menu ini?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _confirmDeleteMenu(menuId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteMenu(String menuId) async {
    isLoading.value = true;
    try {
      final response = await menuManagementRepository.deleteMenu(menuId);

      if (response['success'] == true) {
        AppSnackBar.success(message: response['message'] ?? 'Menu berhasil dihapus');
        loadRolesAndUsers();
      } else {
        AppSnackBar.error(message: response['message'] ?? 'Gagal menghapus menu');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Gagal menghapus menu');
    } finally {
      isLoading.value = false;
    }
  }

// Add this method to your controller
  void sortBy(String column) {
    if (sortColumn.value == column) {
      // Toggle sort direction if clicking the same column
      sortAscending.value = !sortAscending.value;
    } else {
      // Set new sort column and default to ascending
      sortColumn.value = column;
      sortAscending.value = true;
    }

    // Sort the data
    menuList.sort((a, b) {
      var aValue = column == 'name' ? a.name : a.price;
      var bValue = column == 'name' ? b.name : b.price;

      // Compare based on data type
      int result;
      if (aValue is String && bValue is String) {
        result = aValue.compareTo(bValue);
      } else if (aValue is num && bValue is num) {
        result = aValue.compareTo(bValue);
      } else {
        // Convert to string for comparison if types don't match
        result = aValue.toString().compareTo(bValue.toString());
      }

      return sortAscending.value ? result : -result;
    });
  }
}

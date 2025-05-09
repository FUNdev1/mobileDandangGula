import 'dart:io';
import 'package:dandang_gula/app/core/repositories/auth_repository.dart';
import 'package:dandang_gula/app/core/repositories/order_repository.dart';
import 'package:get/get.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../core/repositories/branch_repository.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/api_service.dart';
import 'package:flutter/material.dart';

import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../setting/widget/user_account_side_panel.dart';

class UserManagementController extends GetxController implements UserFormController {
  // Observable variables
  final isLoading = false.obs;
  final users = <User>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final itemsPerPage = 8.obs;

  // Branch related variables
  final branches = [].obs;
  final selectedBranchId = RxnString();
  final isAdminPusat = false.obs;

  // Role filter variables
  final selectedRoleFilter = RxnString();

  // Text controllers
  final selectedUser = Rxn<User?>();

  final searchController = TextEditingController();

  @override
  final isEditing = false.obs;
  @override
  final roles = <Role>[].obs;
  @override
  final isAccountActive = true.obs;
  @override
  final isSubmitting = false.obs;
  @override
  final selectedRoleId = RxnString();
  @override
  final nameController = TextEditingController();
  @override
  final usernameController = TextEditingController();
  @override
  final passwordController = TextEditingController();
  @override
  final pinController = TextEditingController();
  @override
  final selectedImage = Rxn<File?>();

  final authService = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    // Check if user has AdminPusat role
    fetchData(firstTime: true);
  }

  void checkUserRole() {
    // Get current user role from AuthService
    final currentUser = authService.getCurrentUser().value;
    if (currentUser != null) {
      isAdminPusat.value = currentUser.role?.role == 'pusat';

      // If user is AdminPusat, load branches
      if (isAdminPusat.value) {
        loadBranches();
      }
    }
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
    checkUserRole();
    loadRolesAndUsers(firstTime: firstTime);
  }

  void loadRolesAndUsers({bool firstTime = false}) async {
    isLoading.value = true;
    try {
      // First load roles
      final repository = UserRepositoryImpl();
      final rolesResponse = await repository.getAllRoles();

      if (rolesResponse.isNotEmpty) {
        roles.value = rolesResponse;
        if (firstTime) {
          selectedRoleFilter.value = rolesResponse.first.id;
        }

        // Then load users
        final usersResponse = await repository.getUsersPage(
          page: currentPage.value,
          pageSize: itemsPerPage.value,
          search: searchController.text,
          branchId: isAdminPusat.value ? selectedBranchId.value : null,
          roleId: selectedRoleFilter.value,
        );
        if (usersResponse['success'] == true) {
          final userResponse = usersResponse['data'];
          users.value = userResponse.map<User>((user) => User.fromJson(user)).toList();
          totalPages.value = usersResponse['total_page'];
          currentPage.value = usersResponse['page'];
        } else {
          AppSnackBar.error(message: 'Failed to load users: ${usersResponse['message']}');
        }
      } else {
        AppSnackBar.error(message: 'Failed to load roles: error');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchUsers() {
    currentPage.value = 1;
    loadRolesAndUsers();
  }

  void goToPage(int page) {
    if (page != currentPage.value) {
      currentPage.value = page;
      loadRolesAndUsers();
    }
  }

  // Method to open side panel for adding or editing users
  void openUserForm({User? user}) {
    // Reset form fields first
    nameController.clear();
    usernameController.clear();
    passwordController.clear();
    pinController.clear();
    selectedImage.value = null;
    selectedRoleId.value = null;
    isAccountActive.value = true;

    // Set editing state and populate form if editing
    if (user != null) {
      isEditing.value = true;
      selectedUser.value = user;

      // Populate form fields with user data
      nameController.text = user.name;
      usernameController.text = user.username;
      passwordController.text = "";
      pinController.text = user.pin ?? '';
      selectedRoleId.value = user.role?.id ?? selectedRoleFilter.value;
      isAccountActive.value = user.status == 'Active';
    } else {
      isEditing.value = false;
      selectedUser.value = null;
    }

    // Open the panel as a dialog
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            // Clickable overlay to close the dialog
            Expanded(
              child: GestureDetector(
                onTap: closeUserForm,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // The actual side panel
            SizedBox(
              width: 497,
              child: UserAccountSidePanel(controller: this),
            ),
          ],
        ),
      ),
      barrierColor: Colors.transparent,
    );
  }

  // Close the user form panel
  @override
  void closeUserForm() {
    // reset form fields
    nameController.clear();
    usernameController.clear();
    passwordController.clear();
    pinController.clear();
    selectedImage.value = null;
    selectedRoleId.value = null;

    Get.back();
  }

  @override
  void submitUserForm({bool isActive = true}) async {
    if (nameController.text.isEmpty || usernameController.text.isEmpty || (passwordController.text.isEmpty && !isEditing.value) || (pinController.text.isEmpty && !isEditing.value) || selectedRoleId.value == null) {
      AppSnackBar.error(message: 'Harap isi semua kolom wajib');
      return;
    }

    if (pinController.text.isNotEmpty && pinController.text.length != 6) {
      AppSnackBar.error(message: 'PIN harus terdiri dari 6 digit');
      return;
    }

    isSubmitting.value = true;

    try {
      final repository = UserRepositoryImpl();

      // Handle image upload if there's a new image
      String? photoUrl = selectedUser.value?.photoUrl;
      if (selectedImage.value != null) {
        try {
          // Upload image and get URL
          photoUrl = "url";
        } catch (e) {
          AppSnackBar.error(message: 'Gagal mengunggah foto: $e');
        }
      }
      Map<String, dynamic> userData = {
        'name': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'pin': pinController.text,
        'role': selectedRoleId.value,
        'status': isActive ? 'Active' : 'Inactive',
      };
      // Close panel and refresh user list
      closeUserForm();

      if (!isEditing.value) {
        // Create new user with role and status
        final result = await repository.createUser(userData, photoPath: photoUrl);
        if (result['success'] == false) {
          AppSnackBar.error(message: 'Gagal membuat akun: ${result['message']}');
          return;
        }

        AppSnackBar.success(message: result["message"] ?? 'Akun berhasil dibuat');
      } else {
        // Update existing user with role and status
        if (selectedUser.value == null) {
          AppSnackBar.error(message: 'User tidak ditemukan');
          return;
        }
        final result = await repository.updateUser(
          selectedUser.value?.id ?? "",
          userData,
          photoPath: photoUrl,
        );

        if (result['success'] == false) {
          AppSnackBar.error(message: 'Gagal memperbarui akun: ${result['message']}');
          return;
        }
        AppSnackBar.success(message: result["message"] ?? 'Akun berhasil diperbarui');
      }

      loadRolesAndUsers();
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void deleteUser(String id) async {
    try {
      final repository = UserRepositoryImpl();
      final response = await repository.deleteUser(id.toString());
      if (response['success'] == false) {
        AppSnackBar.error(message: 'Gagal menghapus akun: ${response['message']}');
        return;
      }
      AppSnackBar.success(message: response["message"] ?? 'Akun berhasil dihapus');
      loadRolesAndUsers();
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    }
  }

  String _getRoleDisplay(String? role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'kasir':
        return 'Kasir';
      case 'gudang':
        return 'Gudang';
      case 'pusat':
        return 'Pusat';
      case 'branchmanager':
        return 'Branch Manager';
      default:
        return role ?? 'Unknown';
    }
  }

  void onRoleTabSelected(String roleId) async {
    final previousRole = selectedRoleFilter.value;
    selectedRoleFilter.value = roleId;
    isLoading.value = true;
    try {
      final repository = UserRepositoryImpl();
      final usersResponse = await repository.getUsersPage(
        page: 1,
        pageSize: itemsPerPage.value,
        search: searchController.text,
        branchId: isAdminPusat.value ? selectedBranchId.value : null,
        roleId: roleId,
      );
      if (usersResponse['success'] == true) {
        final userResponse = usersResponse['data'];
        users.value = userResponse.map<User>((user) => User.fromJson(user)).toList();
        totalPages.value = usersResponse['total_page'];
        currentPage.value = usersResponse['page'];
      } else {
        AppSnackBar.error(message: 'Failed to load users: ${usersResponse['message']}');
        selectedRoleFilter.value = previousRole;
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load data: $e');
      selectedRoleFilter.value = previousRole;
    } finally {
      isLoading.value = false;
    }
  }

  void onBranchTabSelected(String branchId) async {
    final previousBranch = selectedBranchId.value;
    selectedBranchId.value = branchId;
    isLoading.value = true;
    try {
      final repository = UserRepositoryImpl();
      final usersResponse = await repository.getUsersPage(
        page: 1,
        pageSize: itemsPerPage.value,
        search: searchController.text,
        branchId: branchId,
        roleId: selectedRoleFilter.value,
      );
      if (usersResponse['success'] == true) {
        final userResponse = usersResponse['data'];
        users.value = userResponse.map<User>((user) => User.fromJson(user)).toList();
        totalPages.value = usersResponse['total_page'];
        currentPage.value = usersResponse['page'];
      } else {
        AppSnackBar.error(message: 'Failed to load users: ${usersResponse['message']}');
        selectedBranchId.value = previousBranch;
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load data: $e');
      selectedBranchId.value = previousBranch;
    } finally {
      isLoading.value = false;
    }
  }
}

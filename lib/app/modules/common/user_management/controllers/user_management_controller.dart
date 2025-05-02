import 'dart:io';
import 'package:dandang_gula/app/data/repositories/order_repository.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/repositories/branch_repository.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/services/auth_service.dart';
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
  final roles = [].obs;
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

  final authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    // Check if user has AdminPusat role
    fetchData(firstTime: true);
  }

  void checkUserRole() {
    // Get current user role from AuthService
    final currentUser = authService.currentUser;
    if (currentUser != null) {
      isAdminPusat.value = currentUser.role == 'pusat';

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
      final repository = UserRepository();
      final rolesResponse = await repository.getRoles();

      if (rolesResponse['success'] == true) {
        roles.value = rolesResponse['data'];
        if (firstTime) {
          selectedRoleFilter.value = rolesResponse['data'][0]['id'];
        }

        // Then load users
        final usersResponse = await repository.getUsers(
          page: currentPage.value,
          limit: itemsPerPage.value,
          searchQuery: searchController.text,
          branchId: isAdminPusat.value ? selectedBranchId.value : null,
          roleId: selectedRoleFilter.value,
        );
        if (usersResponse['success'] == true) {
          users.value = usersResponse['data'];
          totalPages.value = usersResponse['totalPages'];
          currentPage.value = usersResponse['page'];
        } else {
          AppSnackBar.error(message: 'Failed to load users: ${usersResponse['message']}');
        }
      } else {
        AppSnackBar.error(message: 'Failed to load roles: ${rolesResponse['message']}');
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
      nameController.text = user.name ?? '';
      usernameController.text = user.username ?? '';
      pinController.text = user.pin ?? '';
      selectedRoleId.value = user.role;
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
      final repository = UserRepository();

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
        final result = await repository.addUser(userData, photoPath: photoUrl);
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
      final repository = UserRepository();
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

  Future<void> viewUserDetails(User user) async {
    // final orderRepo = OrderRepositoryImpl();

    // final resp = await orderRepo.postMenuCreate();
    // if (resp['success'] == false) {
    //   AppSnackBar.error(message: 'Gagal mendapatkan detail user: ${resp['message']}');
    //   return;
    // }

    // Fetch user details from the repository
    // final userDetails = await orderRepo.getUserDetails(user.id);
    // Show user details in a dialog or navigate to details screen
    // Get.dialog(
    //   Dialog(
    //     child: Container(
    //       width: 400,
    //       padding: const EdgeInsets.all(24),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             children: [
    //               Container(
    //                 width: 60,
    //                 height: 60,
    //                 decoration: const BoxDecoration(
    //                   color: Color(0xFF0D4927),
    //                   shape: BoxShape.circle,
    //                 ),
    //                 child: Center(
    //                   child: user.photoUrl != null && user.photoUrl!.isNotEmpty
    //                       ? ClipRRect(
    //                           borderRadius: BorderRadius.circular(30),
    //                           child: Image.network(
    //                             user.photoUrl!,
    //                             width: 60,
    //                             height: 60,
    //                             fit: BoxFit.cover,
    //                             errorBuilder: (_, __, ___) => const Icon(
    //                               Icons.person,
    //                               color: Colors.white,
    //                               size: 30,
    //                             ),
    //                           ),
    //                         )
    //                       : const Icon(
    //                           Icons.person,
    //                           color: Colors.white,
    //                           size: 30,
    //                         ),
    //                 ),
    //               ),
    //               const SizedBox(width: 16),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       user.name ?? '',
    //                       style: const TextStyle(
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     Text(
    //                       _getRoleDisplay(user.role),
    //                       style: const TextStyle(
    //                         fontSize: 14,
    //                         color: Colors.grey,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 24),
    //           const Divider(),
    //           const SizedBox(height: 16),
    //           _detailRow('Email', user.username ?? ''),
    //           _detailRow('Branch', user.branchName ?? ''),
    //           _detailRow('ID', '#${user.id ?? ''}'),
    //           _detailRow('Status', user.status ?? 'Active'),
    //           const SizedBox(height: 24),
    //           Center(
    //             child: ElevatedButton(
    //               onPressed: () => Get.back(),
    //               style: ElevatedButton.styleFrom(
    //                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    //               ),
    //               child: const Text('Close'),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
}

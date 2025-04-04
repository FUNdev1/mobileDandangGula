import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../widget/user_account_side_panel.dart';

class SettingController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Text controllers
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final pinController = TextEditingController();
  final searchController = TextEditingController();

  // Observable variables
  final onSelectedTab = 1.obs;
  final users = <User>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final itemsPerPage = 5.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isEditing = false.obs;
  final selectedUser = Rxn<User?>();
  final selectedImage = Rxn<File?>();

  // Role handling
  final roles = [].obs;
  final selectedRoleId = RxnString();

  // Status handling
  final isAccountActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRoles();
  }

  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    pinController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void loadUsers() async {
    isLoading.value = true;
    try {
      final repository = UserRepository();
      final response = await repository.getUsers(
        page: currentPage.value,
        limit: itemsPerPage.value,
        searchQuery: searchController.text,
      );

      users.value = response.data;
      totalPages.value = response.totalPages;
      currentPage.value = response.page;
    } catch (e) {
      AppSnackBar.error(
        message: 'Failed to load users: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load roles from API
  void loadRoles() async {
    try {
      final repository = UserRepository();

      final response = await repository.getRoles();

      if (response['success'] == true) {
        roles.value = response['data'];
      } else {
        AppSnackBar.error(message: 'Failed to load roles: ${response['message']}');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load roles: $e');
    }
  }

  void searchUsers() {
    currentPage.value = 1;
    loadUsers();
  }

  void goToPage(int page) {
    if (page != currentPage.value) {
      currentPage.value = page;
      loadUsers();
    }
  }

  // Method to open side panel for adding or editing users
  void openUserForm() {
    // Reset form fields
    nameController.clear();
    usernameController.clear();
    passwordController.clear();
    pinController.clear();
    selectedImage.value = null;
    selectedRoleId.value = null;
    isAccountActive.value = true;

    // Open the panel as a dialog instead of trying to animate within the same view
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
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

// Update your existing submitUserForm method to accept roleId and isActive
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

      if (!isEditing.value) {
        // Create new user with role and status
        final result = await repository.addUser(userData, photoPath: photoUrl);
        if (result['success'] == false) {
          AppSnackBar.error(message: 'Gagal membuat akun: ${result['message']}');
          return;
        }

        AppSnackBar.success(message: 'Akun berhasil dibuat');
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
        AppSnackBar.success(message: 'Akun berhasil diperbarui');
      }

      // Close panel and refresh user list
      loadUsers();
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void deleteUser(int id) async {
    try {
      final repository = UserRepository();
      final response = await repository.deleteUser(id.toString());
      if (response['success'] == false) {
        AppSnackBar.error(message: 'Gagal menghapus akun: ${response['message']}');
        return;
      }
      AppSnackBar.success(message: 'Akun berhasil dihapus');
      loadUsers(); // Refresh list
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    }
  }

  void viewUserDetails(User user) {
    // Show user details in a dialog or navigate to details screen
    Get.dialog(
      Dialog(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D4927),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                user.photoUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getRoleDisplay(user.role),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _detailRow('Email', user.username ?? ''),
              _detailRow('Branch', user.branchName ?? ''),
              _detailRow('ID', '#${user.id ?? ''}'),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

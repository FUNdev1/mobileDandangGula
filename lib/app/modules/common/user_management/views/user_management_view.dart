import 'package:dandang_gula/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/services/api_service.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/buttons/app_pagination.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/input/app_dropdown_field.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/user_management_controller.dart';

class UserManagementView extends GetView<UserManagementController> {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final refreshKey = args['refreshKey'] ?? 0;

    return AppLayout(
      key: ValueKey('user_management$refreshKey'),
      content: _buildContent(),
      onRefresh: () async => controller.fetchData(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Branch Filter Tabs (only shown for AdminPusat role)
        Obx(() {
          if (controller.isAdminPusat.value) {
            return _buildBranchTabs();
          } else {
            return const SizedBox.shrink();
          }
        }),

        // Main content
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Role Filter Tabs - Always visible
              _buildRoleTabs(),

              const SizedBox(height: 20),

              // Search and Add User Row
              Row(
                children: [
                  // Search Field
                  SizedBox(
                    width: 219,
                    child: AppTextField(
                      hint: "Cari User",
                      controller: controller.searchController,
                      suffixIcon: AppIcons.search,
                      onSubmitted: (_) => controller.searchUsers(),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Search Button
                  AppButton(
                    label: 'Cari',
                    width: 54,
                    variant: ButtonVariant.outline,
                    outlineBorderColor: const Color(0xFF88DE7B),
                    onPressed: controller.searchUsers,
                  ),

                  const Spacer(),

                  // Add User Button
                  AppButton(
                    label: 'Tambah Akun',
                    width: 153,
                    height: 40,
                    prefixSvgPath: AppIcons.add,
                    onPressed: () => controller.openUserForm(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Table Header
              _buildTableHeader(),

              // User List with Loading State
              Obx(() {
                if (controller.isLoading.value && controller.users.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.users.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: AppText(
                        'No users found',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: controller.users.map((user) => _buildUserRow(user)).toList(),
                );
              }),

              const SizedBox(height: 16),

              // Pagination
              Obx(() {
                return AppPagination(
                  currentPage: controller.currentPage.value,
                  totalPages: controller.totalPages.value,
                  onPageChanged: controller.goToPage,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEDEDED),
            width: 1,
          ),
        ),
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          return Row(
            children: [
              ...controller.roles.map((role) {
                return _buildRoleTab(role['id'], role['role']);
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRoleTab(String roleId, String roleName) {
    final isSelected = controller.selectedRoleFilter.value == roleId;

    return GestureDetector(
      onTap: () {
        controller.selectedRoleFilter.value = roleId;
        controller.searchUsers();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 52,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF88DE7B) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: AppText(
          roleName,
          style: TextStyle(
            color: isSelected ? Color(0xFF88DE7B) : AppColors.darkGreen,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBranchTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 44,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.all(Radius.circular(16))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          return Row(
            children: [
              ...controller.branches.map((branch) {
                return _buildBranchTab(
                  branch['id'],
                  branch['branch_name'],
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBranchTab(String branchId, String branchName) {
    final isSelected = controller.selectedBranchId.value == branchId;

    return GestureDetector(
      onTap: () {
        controller.selectedBranchId.value = branchId;
        controller.searchUsers();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0x1E989898).withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: AppText(
          branchName,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: const Color(0xFFD1D1D1)),
      ),
      child: Row(
        children: [
          // Photo column
          SizedBox(
            width: 92,
          ),

          // Name column
          Expanded(
            flex: 1,
            child: AppText(
              'Nama Lengkap',
              style: AppTextStyles.bodyMedium,
            ),
          ),

          // Username column
          Expanded(
            flex: 1,
            child: AppText(
              'Username',
              style: AppTextStyles.bodyMedium,
            ),
          ),

          // Tanggal dibuat column
          Expanded(
            flex: 1,
            child: AppText(
              'Tanggal dibuat',
              style: AppTextStyles.bodyMedium,
            ),
          ),

          // Status Akun column
          Expanded(
            flex: 1,
            child: AppText(
              'Status Akun',
              style: AppTextStyles.bodyMedium,
            ),
          ),

          // Action column
          const SizedBox(
            width: 75,
            child: Center(
              child: AppText(
                'Action',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(User user) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Profile Photo
          Container(
            width: 92,
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              width: 49,
              height: 49,
              decoration: const BoxDecoration(
                color: Color(0xFF0D4927),
                shape: BoxShape.circle,
              ),
              child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        user.photoUrl!,
                        width: 49,
                        height: 49,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ),

          // Name
          Expanded(
            flex: 1,
            child: AppText(
              user.name ?? '',
              style: AppTextStyles.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Username
          Expanded(
            flex: 1,
            child: AppText(
              user.username ?? '',
              style: AppTextStyles.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Tanggal dibuat
          Expanded(
            flex: 1,
            child: AppText(
              DateFormatter.formatDate(DateTime.tryParse(user.createdAt ?? '')),
              style: AppTextStyles.bodyMedium,
            ),
          ),

          // Status Akun
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  height: 28,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: user.status == 'Active' ? const Color(0xFFE8EFF8) : Color(0xFFFCEEEE),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  width: 71, // Set the width here
                  child: AppText(
                    user.status == 'Active' ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: user.status == 'Active' ? const Color(0xFF0D4927) : Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Spacer(),
          // Action
          SizedBox(
            width: 75,
            child: Center(
              child: _buildActionButton(user),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(User user) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 32),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEAEEF2)),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          AppIcons.overflowMenuHorizontal,
          height: 16,
          width: 16,
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case 'view':
            controller.viewUserDetails(user);
            break;
          case 'edit':
            controller.openUserForm(user: user);
            break;
          case 'delete':
            _showDeleteConfirmation(user);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              const Icon(Icons.visibility, size: 16),
              const SizedBox(width: 8),
              AppText(
                'View',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 16),
              const SizedBox(width: 8),
              AppText(
                'Edit',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              AppText(
                'Delete',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(User user) {
    Get.dialog(
      AlertDialog(
        title: const AppText('Confirm Delete'),
        content: AppText('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const AppText('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (user.id != null) {
                controller.deleteUser(user.id!);
              }
            },
            child: const AppText(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

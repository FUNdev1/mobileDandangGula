import 'package:dandang_gula/app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../data/models/user_model.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/buttons/app_pagination.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/setting_controller.dart';

class PengaturanAkunTabPages extends StatefulWidget {
  const PengaturanAkunTabPages({super.key});

  @override
  State<PengaturanAkunTabPages> createState() => _PengaturanAkunTabPagesState();
}

class _PengaturanAkunTabPagesState extends State<PengaturanAkunTabPages> {
  late final SettingController controller;
  String? selectedRole;
  String? selectedBranch;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SettingController>();
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Main content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search and Action Row
                  Row(
                    children: [
                      // Search Field
                      SizedBox(
                        width: 219,
                        child: AppTextField(
                          hint: "Cari User",
                          controller: controller.searchController,
                          onFocusChanged: (_) => controller.searchUsers(),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Search Button
                      AppButton(
                        label: 'Cari',
                        height: 50,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AppText('Foto Profil', style: AppTextStyles.bodyMedium),
            ),
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
            controller.openUserForm();
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
                controller.deleteUser(int.parse(user.id ?? "0"));
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

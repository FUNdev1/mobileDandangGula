import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils.dart';
import '../../core/controllers/navigation_controller.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../buttons/icon_button.dart';
import '../text/app_text.dart';

enum UserRole {
  admin,
  kasir,
  gudang,
  pusat,
  supervisor,
}

class AppLayout extends StatelessWidget {
  final Widget content;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  final AuthService _authService = Get.find<AuthService>();
  final NavigationController _navigationController = Get.find<NavigationController>();

  AppLayout({
    super.key,
    required this.content,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.onRefresh,
    this.title = '',
    this.showBackButton = false,
    this.onBackPressed,
  });

  UserRole _getUserRoleEnum() {
    switch (_authService.userRole) {
      case 'admin':
        return UserRole.admin;
      case 'kasir':
        return UserRole.kasir;
      case 'gudang':
        return UserRole.gudang;
      case 'pusat':
        return UserRole.pusat;
      case 'supervisor':
        return UserRole.supervisor;
      default:
        return UserRole.kasir;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If we're showing a back button, use its handler
        if (showBackButton && onBackPressed != null) {
          onBackPressed!();
          return false;
        }

        // Otherwise, let the navigation controller handle it
        // You would implement handleBackNavigation in your NavigationController
        if (_navigationController.routeHistory.length > 1) {
          _navigationController.handleBackNavigation();
          return false;
        }

        // Allow the app to be closed if we're at the root
        return true;
      },
      child: ColoredBox(
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // App Bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 12,
                        right: 24,
                        bottom: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNavigation(),
                          const SizedBox(width: 12),
                          _buildUserProfile(),
                        ],
                      ),
                    ),

                    // Content
                    Obx(() {
                      final route = _navigationController.currentRoute.value;
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: KeyedSubtree(
                          // Tambahkan timestamp untuk memastikan key selalu berbeda
                          key: ValueKey('$route-$timestamp'),
                          child: content,
                        ),
                      );
                    }),

                    Obx(() {
                      if (_navigationController.isNavigating.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ],
                ),
              ),
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Expanded(
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardPadding),
        ),
        child: Row(
          children: [
            // Back button if needed
            if (showBackButton) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Get.back(),
              ),
              const SizedBox(width: 8),
            ],

            // App logo
            Image.asset(
              AppIcons.appIcon,
              height: 50,
              width: 50,
            ),

            // Page title if provided
            if (title.isNotEmpty) ...[
              const SizedBox(width: AppDimensions.spacing16),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              const SizedBox(width: AppDimensions.spacing16),
              _buildNavigationItems(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItems() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          return Row(
            children: _getNavigationItemsByRole(),
          );
        }),
      ),
    );
  }

  List<Widget> _getNavigationItemsByRole() {
    final navItems = <Widget>[];
    final currentRole = _getUserRoleEnum();
    final currentRoute = _navigationController.currentRoute.value;

    // Add Dashboard button for all roles
    navItems.add(
      _buildNavItem(
        'Dashboard',
        AppIcons.dashboard,
        currentRoute == Routes.DASHBOARD,
        Routes.DASHBOARD,
      ),
    );

    // Add role-specific menu items
    switch (currentRole) {
      case UserRole.admin:
        navItems.addAll([
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            currentRoute == Routes.STOCK_MANAGEMENT,
            Routes.STOCK_MANAGEMENT,
          ),
          _buildNavItem(
            'Manajemen Menu',
            AppIcons.restaurant,
            currentRoute == "",
            "",
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == "",
            "",
          ),
          _buildNavItem(
            'Manajemen User',
            AppIcons.userAccess,
            currentRoute == "",
            "",
          ),
        ]);
        break;

      case UserRole.kasir:
        navItems.addAll([
          _buildNavItem(
            'Pesanan',
            AppIcons.orderDetails,
            currentRoute == Routes.ORDERS,
            Routes.ORDERS,
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == "",
            "",
          ),
          _buildNavItem(
            'Presensi',
            AppIcons.userAccess,
            currentRoute == Routes.ATTENDANCE,
            Routes.ATTENDANCE,
          ),
        ]);
        break;

      case UserRole.gudang:
        navItems.addAll([
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            currentRoute == Routes.STOCK_MANAGEMENT,
            Routes.STOCK_MANAGEMENT,
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == "",
            "",
          ),
        ]);
        break;

      case UserRole.pusat:
        navItems.addAll([
          _buildNavItem(
            'Manajemen Cabang',
            AppIcons.orderDetails,
            currentRoute == "",
            "",
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            currentRoute == Routes.USER_MANAGEMENT,
            Routes.USER_MANAGEMENT,
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == "",
            "",
          ),
        ]);
        break;

      case UserRole.supervisor:
        navItems.addAll([
          _buildNavItem(
            'Management Menu',
            AppIcons.restaurant,
            currentRoute == Routes.MENU_MANAGEMENT,
            Routes.MENU_MANAGEMENT,
          ),
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            currentRoute == Routes.STOCK_MANAGEMENT,
            Routes.STOCK_MANAGEMENT,
          ),
          _buildNavItem(
            'Pesanan',
            AppIcons.orderDetails,
            currentRoute == Routes.ORDERS,
            Routes.ORDERS,
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == "",
            "",
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            currentRoute == Routes.USER_MANAGEMENT,
            Routes.USER_MANAGEMENT,
          ),
        ]);
        break;
    }

    return navItems;
  }

  Widget _buildNavItem(String label, String iconPath, bool isActive, String routeName) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          _navigationController.changePage(routeName);
        },
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      iconPath,
                      colorFilter: ColorFilter.mode(
                        isActive ? AppColors.accent : AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w400,
                      color: isActive ? AppColors.accent : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Rest of the UI elements...
            if (isActive)
              Positioned(
                top: 2,
                left: 2,
                right: 2,
                bottom: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),

            if (isActive)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          iconPath,
                          colorFilter: const ColorFilter.mode(
                            AppColors.accent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        label,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          color: isActive ? AppColors.accent : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // User profile and other methods remain the same...
  Widget _buildUserProfile() {
    // Your existing implementation...
    return Obx(() {
      final user = _authService.currentUser;
      final userName = user?.name ?? 'User';
      final roleName = _authService.userRole;
      final isShowSetting = _authService.userRole == "pusat" || _authService.userRole == "supervisor" || _authService.userRole == "kasir";
      final isShowNotif = _authService.userRole != "kasir";

      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardPadding),
        ),
        child: Row(
          children: [
            if (isShowSetting) ...[
              AppIconButton(
                icon: AppIcons.settings,
                onPressed: () {
                  Get.toNamed('/settings');
                },
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: AppDimensions.spacing12),
            ],
            if (isShowNotif) ...[
              AppIconButton(
                icon: AppIcons.notification,
                onPressed: () {
                  // Handle notifications
                },
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: AppDimensions.spacing12),
            ],
            _buildUserAvatar(userName, roleName),
          ],
        ),
      );
    });
  }

  Widget _buildUserAvatar(String userName, String roleName) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: _authService.currentUser?.photoUrl != null && _authService.currentUser!.photoUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: _authService.currentUser!.photoUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => _buildDefaultAvatar(),
                  )
                : _buildDefaultAvatar(),
          ),
          const SizedBox(width: AppDimensions.spacing10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: AppText(
                    userName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AppText(
                roleName.capitalizeFirst ?? "",
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'logout',
            child: AppText.body('Logout'),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'logout':
            _authService.logout();
            break;
        }
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          _authService.currentUser?.name?.substring(0, 1).toUpperCase() ?? 'U',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandang_gula/app/global_widgets/buttons/app_button.dart';
import 'package:dandang_gula/app/global_widgets/buttons/icon_button.dart';
import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/utils.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../core/utils/theme/app_dimensions.dart';
import '../controllers/kasir_dashboard_controller.dart';
import 'components/kasir/pembayaran_page.dart';

class KasirDashboardView extends StatelessWidget {
  final controller = DashboardController.to as KasirDashboardController;

  KasirDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Calculate the approximate available height after accounting for app bar
    final availableHeight = screenHeight - 150; // Adjust this value as needed

    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        children: [
          // Categories
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: SizedBox(height: 2, width: double.infinity, child: LinearProgressIndicator()),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.menuPage.isEmpty ? 1 : controller.menuPage.length,
                itemBuilder: (context, index) {
                  if (controller.menuPage.isEmpty) {
                    return const SizedBox(width: 100, height: 40);
                  }

                  final e = controller.menuPage[index];
                  return _buildCategoryChip(e["category_name"] ?? "-", controller.selectedStockGroup.value == e["id"], e["items"]?.toString() ?? "0");
                },
              );
            }),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: availableHeight - 62, // 50 (category height) + 12 (spacing)
            child: Row(
              children: [
                // Left side - Menu Section
                Expanded(
                  flex: 2,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.menuList.isEmpty && !controller.isLoading.value) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCustomMenuButton(),
                          const SizedBox(height: 16),
                          const Text('Tidak ada menu tersedia'),
                        ],
                      );
                    }

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Adjust based on available width
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.menuList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildCustomMenuButton();
                        }
                        final adjustedIndex = index - 1;
                        if (adjustedIndex < controller.menuList.length) {
                          return _buildMenuCard(adjustedIndex);
                        } else {
                          return Container();
                        }
                      },
                    );
                  }),
                ),
                // Right side - Placeholder for now
// Right side - Order Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order type section
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Type selection (header)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Tipe Pesanan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepWiseBlue,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.caretRight,
                                      height: 16,
                                      width: 16,
                                      color: AppColors.deepWiseBlue,
                                    ),
                                  ],
                                ),
                              ),
                              // Divider
                              Container(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              // Selected order type
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.restaurant,
                                      height: 16,
                                      width: 16,
                                      color: AppColors.black,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Dine in',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepWiseBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Customer name section
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Atas Nama',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepWiseBlue,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('Tuliskan nama...', style: TextStyle(color: Colors.grey)),
                                    SvgPicture.asset(
                                      AppIcons.caretRight,
                                      height: 16,
                                      width: 16,
                                      color: AppColors.deepWiseBlue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Order details section - This is likely causing issues
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rincian pesanan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepWiseBlue,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // List of selected items - FIXED VERSION
                                Flexible(
                                  child: Obx(() {
                                    if (controller.selectedItems.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AppText(
                                              'Belum ada pesanan',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            AppText(
                                              "Pesanan yang kamu pilih akan tampil disini",
                                            )
                                          ],
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: controller.selectedItems.length,
                                      itemBuilder: (context, index) {
                                        final item = controller.selectedItems[index];
                                        return _buildOrderItem(
                                          item['name'] ?? '',
                                          item['price'] ?? '',
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            // Order summary - totals
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  _buildOrderSummaryRow('Subtotal', CurrencyFormatter.formatRupiah(controller.subtotal.value)),
                                  _buildOrderSummaryRow('Biaya Layanan', CurrencyFormatter.formatRupiah(controller.serviceFee.value)),
                                  _buildOrderSummaryRow('Total', CurrencyFormatter.formatRupiah(controller.total.value), isTotal: true),
                                  const SizedBox(height: 16),

                                  // Payment buttons
                                  Row(
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          height: 56,
                                          child: AppButton(
                                            label: "Bayar Nanti",
                                            onPressed: () {},
                                            variant: ButtonVariant.outline,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: SizedBox(
                                          height: 56,
                                          child: AppButton(
                                            label: "Bayar Sekarang\nTotal 3 Produk",
                                            suffixSvgPath: AppIcons.caretRight,
                                            customBackgroundColor: Color(0xFF1B9851),
                                            onPressed: () {
                                              Get.to(() {
                                                return PembayaranPage(selectedItems: controller.selectedItems.value);
                                              })?.then((result) {
                                                if (result != null && result['success'] == true) {
                                                  Get.snackbar(
                                                    'Pembayaran Berhasil',
                                                    'Transaksi telah selesai',
                                                    backgroundColor: Colors.green,
                                                    colorText: Colors.white,
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, String count) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          _setCurrentCategory(label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B9851) : null,
            borderRadius: BorderRadius.circular(54),
            border: Border.all(color: isSelected ? Color(0xFF136C3A) : Color(0xFFD4D4D4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Color(0xFFE9FBF1) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (count.isNotEmpty)
                Text(
                  ' ($count items) ',
                  style: TextStyle(
                    color: isSelected ? Colors.white.withOpacity(0.52) : Color(0xFF3C3C4399).withOpacity(0.60),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMenuButton() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 165,
        minHeight: 120,
        minWidth: 163,
        maxWidth: 201,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF1B9851),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.add,
              height: 24,
              width: 24,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              'Buat Custom Menu',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(int index) {
    // Double-check index bounds for safety
    if (index < 0 || index >= controller.menuList.length) {
      return Container(); // Return empty container if index is out of bounds
    }

    var menuItem = controller.menuList[index];

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 165,
        maxWidth: 201,
        minWidth: 163,
        minHeight: 120,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 75,
                child: CachedNetworkImage(
                  imageUrl: menuItem.photoUrl ?? "",
                  errorWidget: (context, url, error) => Image.asset(
                    AppIcons.appIcon,
                    height: 75,
                    width: 75,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    menuItem.categoryName ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menuItem.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    CurrencyFormatter.formatRupiah(menuItem.price ?? 0),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          AppIconButton(
            icon: AppIcons.close,
            backgroundColor: Colors.white,
            size: 32,
            iconSize: 16,
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price),
              ],
            ),
          ),
          Row(
            children: [
              AppIconButton(
                icon: AppIcons.minus,
                backgroundColor: Color(0xFF136C3A),
                iconColor: Colors.white,
                size: 32,
                iconSize: 16,
                onPressed: () {},
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: const AppText('1'),
              ),
              AppIconButton(
                icon: AppIcons.add,
                backgroundColor: Color(0xFF136C3A),
                iconColor: Colors.white,
                size: 32,
                iconSize: 16,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 12),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 16 : 12),
          ),
        ],
      ),
    );
  }

  void _setCurrentCategory(String category) {
    try {
      // Cari ID kategori berdasarkan nama
      for (var item in controller.menuPage) {
        if (item['category_name'] == category) {
          // Make sure to use the correct key
          final id = item['id'];
          if (id != null) {
            controller.selectedStockGroup.value = id;
            controller.loadDashboardData();
          }
          break;
        }
      }
    } catch (e) {
      print('Error setting category: $e');
    }
  }

  showPresensiDialog() {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        alignment: Alignment.centerRight,
        child: Container(
          height: Get.height,
          width: Get.width * 0.3,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D4927),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.authService.getCurrentUser().value?.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.authService.getCurrentUser().value?.role?.role ?? "-",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 180,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEEF2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                '${DateTime.now().hour}:${DateTime.now().second}:${DateTime.now().microsecond}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF11373E),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Akhiri Sesi',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Pendapatan Hari Ini
              GestureDetector(
                onTap: () {
                  // Handle click
                  _onTapCardPresensi("Tunai");
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF23C368),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pendapatan Hari Ini',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Rp. 100.000',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF23C368),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Rp. 100.000',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Tunai
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF1B9851),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tunai',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Rp. 100.000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      //Non Tunai
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF1B9851),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Non Tunai',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Rp. 100.000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onTapCardPresensi(String title) {
    if (Get.isDialogOpen!) Get.back();
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        alignment: Alignment.centerRight,
        child: Container(
          height: Get.height,
          width: Get.width * 0.3,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(
                        AppIcons.close,
                        color: Color(0xFF11373E),
                        height: 24,
                        width: 24,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF11373E),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF1B9851),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Saldo $title',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rp 380.000',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // Tab untuk Semua Transaksi dan Kas Manual
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        indicatorColor: AppColors.deepWiseGreen,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Color(0xFFEAEEF2),
                        labelColor: AppColors.deepWiseGreen,
                        indicatorWeight: 1,
                        unselectedLabelColor: AppColors.darkGreen80,
                        tabs: [
                          Container(
                            child: Text(
                              "Semua Transaksi",
                            ),
                          ),
                          Container(
                            child: Text(
                              "Kas Manual",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konten Tab
                    Flexible(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // Tab Semua Transakssi
                          _buildSemuaTransaksi(),

                          // Tab Kas Manual
                          _buildKasManual(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan semua transaksi
  Widget _buildSemuaTransaksi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Date Picker
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hari ini',
                  style: TextStyle(fontSize: 14),
                ),
                Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Transaksi List
          Flexible(
            child: ListView(
              children: [
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '16:00 WIB',
                  description: 'Beli Pengharum Ruangan',
                  amount: -10000,
                ),
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '14:00 WIB',
                  description: 'Beli Lampu Bohlam',
                  amount: -10000,
                ),
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '14:00 WIB',
                  description: '',
                  amount: 100000,
                ),
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '14:00 WIB',
                  description: '',
                  amount: 100000,
                ),
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '14:00 WIB',
                  description: '',
                  amount: 100000,
                ),
              ],
            ),
          ),

          // Tambah Transaksi Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () {
                // Implementasi tambah transaksi
                _showTambahTransaksiDialog();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Transaksi',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan kas manual
  Widget _buildKasManual() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Date Picker
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hari ini',
                  style: TextStyle(fontSize: 14),
                ),
                Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Transaksi List - Kas Manual
          Flexible(
            child: ListView(
              children: [
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '16:00 WIB',
                  description: 'Beli Pengharum Ruangan',
                  amount: -10000,
                ),
                _buildTransactionItem(
                  date: '14 Februari 2025',
                  time: '14:00 WIB',
                  description: 'Beli Lampu Bohlam',
                  amount: -10000,
                ),
              ],
            ),
          ),

          // Tambah Transaksi Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () {
                // Implementasi tambah transaksi
                _showTambahTransaksiDialog();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Transaksi',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk item transaksi
  Widget _buildTransactionItem({
    required String date,
    required String time,
    required String description,
    required int amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${amount > 0 ? '+' : ''}${CurrencyFormatter.formatRupiah(amount.toDouble())}',
                style: TextStyle(
                  color: amount > 0 ? AppColors.primary : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dialog untuk menambah transaksi baru
  void _showTambahTransaksiDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    bool isExpense = false;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Transaksi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Jenis Transaksi
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () => setState(() => isExpense = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: !isExpense ? AppColors.primary : Colors.white,
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Pemasukan',
                              style: TextStyle(
                                color: !isExpense ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () => setState(() => isExpense = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isExpense ? AppColors.primary : Colors.white,
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Pengeluaran',
                              style: TextStyle(
                                color: isExpense ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),

              // Jumlah
              AppTextField(
                controller: amountController,
                label: 'Jumlah',
                hint: 'Masukkan jumlah',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // Keterangan
              AppTextField(
                controller: descriptionController,
                label: 'Keterangan',
                hint: 'Masukkan keterangan (opsional)',
              ),
              SizedBox(height: 24),

              // Tombol Simpan
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Batal',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        // Implementasi simpan transaksi
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

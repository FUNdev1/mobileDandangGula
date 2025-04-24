import 'package:dandang_gula/app/global_widgets/buttons/app_button.dart';
import 'package:dandang_gula/app/global_widgets/buttons/icon_button.dart';
import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/utils.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../controllers/kasir_dashboard_controller.dart';
import 'components/kasir/pembayaran_page.dart';

class KasirDashboardView extends StatelessWidget {
  final controller = DashboardController.to as KasirDashboardController;

  KasirDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.contentPadding,
      child: Column(
        children: [
          // Categories
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...controller.menuPage.map((e) {
                      return _buildCategoryChip(e["group_name"], controller.selectedStockGroup.value == e["id"], e["items"].toString());
                    }),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Left side - Menu Section
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  height: Get.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search and Sort
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width * 0.3,
                            child: AppTextField(
                              hint: 'Cari Menu',
                              suffixIcon: AppIcons.search,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Text('Sort by'),
                                SizedBox(width: 8),
                                Text('A - Z'),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Menu Grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 13,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildCustomMenuButton();
                            }
                            return _buildMenuCard(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right side - Order Section
              Expanded(
                child: Container(
                  height: Get.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
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
                            Container(
                              height: 1,
                              decoration: BoxDecoration(color: Colors.grey[200]),
                            ),
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
                      Container(
                        height: 293,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
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
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (controller.selectedItems.isNotEmpty)
                                    ...controller.selectedItems.map((element) {
                                      return _buildOrderItem(
                                        element['name'],
                                        element['price'],
                                      );
                                    })
                                  else
                                    SizedBox(
                                      width: double.infinity,
                                      child: Column(
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
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            _buildOrderSummaryRow('Subtotal', CurrencyFormatter.formatRupiah(75000)),
                            _buildOrderSummaryRow('Biaya layanan', CurrencyFormatter.formatRupiah(10000)),
                            Container(
                              height: 1,
                              decoration: BoxDecoration(color: Colors.grey[200]),
                            ),
                            // Total sectio
                            _buildOrderSummaryRow('Total', CurrencyFormatter.formatRupiah(76000), isTotal: true),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
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
                                // Update the "Bayar Sekarang" button to open the payment page
                                Expanded(
                                  child: SizedBox(
                                    height: 56,
                                    child: AppButton(
                                      label: "Bayar Sekarang\nTotal 3 Produk",
                                      suffixSvgPath: AppIcons.caretRight,
                                      customBackgroundColor: Color(0xFF1B9851),
                                      onPressed: () {
                                        // Get the selected items from the order
                                        // List<Map<String, dynamic>> selectedItems = [
                                        //   {'name': 'Nasi Ayam Lada Hitam', 'price': 'Rp25,000', 'quantity': 1},
                                        //   {'name': 'Cumi Telur Asin', 'price': 'Rp25,000', 'quantity': 1},
                                        //   {'name': 'Nasi Goreng Spesial', 'price': 'Rp25,000', 'quantity': 1},
                                        // ];

                                        // Open the payment page

                                        Get.to(() {
                                          return PembayaranPage(selectedItems: controller.selectedItems.value);
                                        })?.then((result) {
                                          if (result != null && result['success'] == true) {
                                            // Handle successful payment
                                            // For example, clear the cart, show a success message, etc.
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
                    ],
                  ),
                ),
              ),
            ],
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
    // return Container(
    //   margin: const EdgeInsets.only(right: 8),
    //   child: FilterChip(
    //     selected: isSelected,
    //     label: Text('$label ($count items)'),
    //     onSelected: (bool value) {},
    //     backgroundColor: Colors.grey[200],
    //     selectedColor: Colors.green,
    //     labelStyle: TextStyle(
    //       color: isSelected ? Colors.white : Colors.black,
    //     ),
    //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    //   ),
    // );
  }

  Widget _buildCustomMenuButton() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 165,
        maxWidth: 201,
        minWidth: 163,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.add,
                height: 39,
                width: 41,
                color: Colors.white,
              ),
              Text(
                'Buat Custom Menu',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(int index) {
    // List<Map<String, dynamic>> menuItems = [
    //   {'name': 'Nasi Ayam Lada Hitam', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Rawon Surabaya', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Soto Betawi', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Sapi Bulgogi Lada Hitam', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Ikan Sambal Matah', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Cumi Telur Asin', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Bihun Goreng Dandang Tempoe Doeloe', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Nasi Goreng Spesial', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Mie Goreng India', 'price': 'Rp 25,000', 'category': 'Main Dish'},
    //   {'name': 'Sate Maranggi Sriwedari', 'price': 'Rp 25,000', 'category': 'Pesona Nusantara'},
    //   {'name': 'Salmon Steak', 'price': 'Rp 25,000', 'category': 'Steak & Grill'},
    //   {'name': 'Chicken Cordon Blue', 'price': 'Rp 25,000', 'category': 'Pasta Fiesta'},
    // ];

    if (index - 1 >= controller.menuCards.length) {
      return Container();
    }

    var menuItem = controller.menuCards[index - 1];

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 165,
        maxWidth: 201,
        minWidth: 163,
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
              Container(
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/200?random=$index'),
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(menuItem.categoryName),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menuItem.menuName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    CurrencyFormatter.formatRupiah(menuItem.price), // Format harga men
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
          Expanded(
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

  void _setCurrentCategory(category) {}
}

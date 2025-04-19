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

class KasirDashboardView extends StatelessWidget {
  final DashboardController controller;

  const KasirDashboardView({super.key, required this.controller});

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
                    ...controller.listStockGroup.map((e) {
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
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildOrderItem('Nasi Ayam Lada Hitam', 'Rp25,000'),
                                    _buildOrderItem('Cumi Telur Asin', 'Rp25,000'),
                                    _buildOrderItem('Nasi Goreng Spesial', 'Rp25,000'),
                                  ],
                                ),
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
                                Expanded(
                                  child: SizedBox(
                                    height: 56,
                                    child: AppButton(
                                      label: "Bayar Sekarang\nTotal 3 Produk",
                                      suffixSvgPath: AppIcons.caretRight,
                                      onPressed: () {},
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
    List<Map<String, dynamic>> menuItems = [
      {'name': 'Nasi Ayam Lada Hitam', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Rawon Surabaya', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Soto Betawi', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Sapi Bulgogi Lada Hitam', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Ikan Sambal Matah', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Cumi Telur Asin', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Bihun Goreng Dandang Tempoe Doeloe', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Nasi Goreng Spesial', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Mie Goreng India', 'price': 'Rp 25,000', 'category': 'Main Dish'},
      {'name': 'Sate Maranggi Sriwedari', 'price': 'Rp 25,000', 'category': 'Pesona Nusantara'},
      {'name': 'Salmon Steak', 'price': 'Rp 25,000', 'category': 'Steak & Grill'},
      {'name': 'Chicken Cordon Blue', 'price': 'Rp 25,000', 'category': 'Pasta Fiesta'},
    ];

    if (index - 1 >= menuItems.length) {
      return Container();
    }

    var menuItem = menuItems[index - 1];

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
                  child: Text(menuItem['category']),
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
                    menuItem['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    menuItem['price'],
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.remove, color: Colors.white),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: const Text('1'),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.add, color: Colors.white),
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

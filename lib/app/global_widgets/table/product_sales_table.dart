import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../../core/utils.dart';
import '../../data/models/product_sales_model.dart';

class ProductSalesTable extends StatelessWidget {
  final String title;
  final List<ProductSales> products;
  final VoidCallback onViewAll;
  final double height;

  const ProductSalesTable({
    super.key,
    required this.title,
    required this.products,
    required this.onViewAll,
    this.height = 410,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 18 / 14,
                  color: Colors.black,
                ),
              ),
              InkWell(
                onTap: onViewAll,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lainya',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 16 / 12,
                        color: Color(0xFF017AEB),
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      AppIcons.caretRight,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF017AEB),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Table header
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      'Produk',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 17 / 14,
                        letterSpacing: -0.06,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Total Pesanan',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 17 / 14,
                        letterSpacing: -0.06,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      'Total Penjualan',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 17 / 14,
                        letterSpacing: -0.06,
                        color: Color(0xFF888888),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table rows
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return _buildProductRow(products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(ProductSales product) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5EA),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDBDBD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 15 / 12,
                    letterSpacing: -0.06,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                CurrencyFormatter.formatThousands(product.orderCount.toDouble(), decimalDigits: 0),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 15 / 12,
                  letterSpacing: -0.06,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                'Rp${CurrencyFormatter.formatThousands(product.totalSales, decimalDigits: 0)}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 15 / 12,
                  letterSpacing: -0.06,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

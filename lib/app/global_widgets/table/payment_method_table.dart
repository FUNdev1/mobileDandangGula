import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';
import '../../data/models/payment_method_model.dart';
import '../../core/utils.dart';

class PaymentMethodTable extends StatelessWidget {
  final String title;
  final List<PaymentMethod> paymentMethods;
  final VoidCallback onViewAll;
  final double height;
  final double width;

  const PaymentMethodTable({
    Key? key,
    required this.title,
    required this.paymentMethods,
    required this.onViewAll,
    this.height = 410,
    this.width = 450.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
          // Title and action row
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
                      'assets/icons/caret-right.svg',
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

          // Payment method list
          Expanded(
            child: ListView.separated(
              itemCount: paymentMethods.length,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildPaymentMethodRow(paymentMethods[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(PaymentMethod method) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Payment method icon
            SizedBox(
              width: 60,
              height: 60,
              child: _getPaymentIcon(method),
            ),
            const SizedBox(width: 10),
            // Payment method name
            Text(
              method.name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 17 / 14,
                letterSpacing: -0.06,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
        // Payment amount
        Text(
          'Rp${CurrencyFormatter.formatThousands(method.amount, decimalDigits: 0)}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 17 / 14,
            letterSpacing: -0.06,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _getPaymentIcon(PaymentMethod method) {
    // Maps payment method type to the appropriate icon
    switch (method.id) {
      case "1": // Cash
        return SvgPicture.asset(
          AppIcons.dollar,
        );
      case "2": // QRIS
        return SvgPicture.asset(
          AppIcons.qris,
        );
      case "3": // EDC
        return SvgPicture.asset(
          AppIcons.edc,
        );
      default:
        return Icon(
          method.icon,
          size: 30,
          color: Colors.black,
        );
    }
  }
}

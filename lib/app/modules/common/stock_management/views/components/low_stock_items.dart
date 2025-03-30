import 'package:flutter/material.dart';
import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../data/models/stock_alert_model.dart';
import '../../../../../global_widgets/text/app_text.dart';

class LowStockItems extends StatelessWidget {
  final List<StockAlert> items;

  const LowStockItems({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: AppText('Stok akan habis'),
        ),

        SizedBox(height: 10),
        // Scrollable cards
        SizedBox(
          width: double.infinity,
          height: 128,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildStockAlertCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStockAlertCard(StockAlert item) {
    return Container(
      width: 208,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              item.name,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 20),

          // Stock amount row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sisa',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontFamily: 'IBM Plex Mono',
                      color: const Color(0xB8171F26),
                      letterSpacing: -0.1,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.amount.split(' ')[0],
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.amount.split(' ').length > 1 ? item.amount.split(' ')[1] : '',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontFamily: 'IBM Plex Mono',
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF999999),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 11),

          // Progress bar
          LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            return Container(
              height: 14,
              width: maxWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 208 * item.alertLevel,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDF0000),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../core/models/stock_model.dart';
import '../../../../../core/utils/theme/app_text_styles.dart';
import '../../../../../global_widgets/text/app_text.dart';

class LowStockItems extends StatefulWidget {
  final List<StockAlert> items;

  const LowStockItems({
    super.key,
    required this.items,
  });

  @override
  State<LowStockItems> createState() => _LowStockItemsState();
}

class _LowStockItemsState extends State<LowStockItems> {
  final ValueNotifier<double> selectedValue = ValueNotifier<double>(0.0);

  @override
  void dispose() {
    selectedValue.dispose();
    super.dispose();
  }

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

        const SizedBox(height: 10),
        // Scrollable cards
        SizedBox(
          width: double.infinity,
          height: 128,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return GestureDetector(
                onTap: () {
                  selectedValue.value = item.stock / item.limit;
                },
                child: _buildStockAlertCard(item),
              );
            },
          ),
        ),
        // const SizedBox(height: 20),
        // // Display selected value for demonstration
        // ValueListenableBuilder<double>(
        //   valueListenable: selectedValue,
        //   builder: (context, value, child) {
        //     return Text(
        //       'Selected Value: ${(value * 100).toStringAsFixed(1)}%',
        //       style: AppTextStyles.bodyMedium,
        //     );
        //   },
        // ),
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
                        item.stock.toStringAsFixed(0).toString(),
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.name,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              // Calculate the red portion width based on the current stock level
              final redWidth = (maxWidth * _normalizeAlertLevel(item.stock / item.limit)).clamp(0.0, maxWidth);

              return Container(
                height: 14,
                width: maxWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8), // Gray background
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: redWidth,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDF0000), // Red foreground
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper method to normalize the alert level to a value between 0.0 and 1.0
  double _normalizeAlertLevel(double level) {
    // Ensure the alert level is between 0.0 and 1.0
    return level.clamp(0.0, 1.0);
  }
}

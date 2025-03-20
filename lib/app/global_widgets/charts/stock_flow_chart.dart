import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/stock_flow_data_model.dart';
import '../text/app_text.dart';

class StockFlowChart extends StatelessWidget {
  final List<StockFlowData> data;

  const StockFlowChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem(Colors.green, 'Penjualan'),
            const SizedBox(width: 12),
            _buildLegendItem(Colors.blue, 'Pembelian'),
            const SizedBox(width: 12),
            _buildLegendItem(Colors.amber, 'Terbuang'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: data.map((item) {
              // Find max value for scaling
              final maxValue = [item.sales, item.purchases, item.wastage].reduce((a, b) => a > b ? a : b);

              // Scale heights (max height 200)
              final salesHeight = (item.sales / maxValue) * 200;
              final purchasesHeight = (item.purchases / maxValue) * 200;
              final wastageHeight = (item.wastage / maxValue) * 200;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildBar(salesHeight, Colors.green),
                    const SizedBox(height: 2),
                    _buildBar(purchasesHeight, Colors.blue),
                    const SizedBox(height: 2),
                    _buildBar(wastageHeight, Colors.amber),
                    const SizedBox(height: 8),
                    AppText(
                      item.date,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        AppText(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 10,
      height: height,
      color: color,
    );
  }
}

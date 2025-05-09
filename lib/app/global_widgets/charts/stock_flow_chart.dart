import 'package:flutter/material.dart';
import '../../core/models/stock_model.dart';
import '../../core/utils/theme/app_text_styles.dart';
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

    // Map data untuk chart
    final Map<String, Map<String, double>> groupedData = {};

    for (var item in data) {
      if (!groupedData.containsKey(item.date)) {
        groupedData[item.date] = {
          'purchase': 0,
          'usage': 0,
          'balance': 0,
        };
      }

      // stockIn adalah pembelian/purchase
      groupedData[item.date]!['purchase'] = (groupedData[item.date]!['purchase'] ?? 0) + item.stockIn;

      // stockOut adalah penggunaan/usage
      groupedData[item.date]!['usage'] = (groupedData[item.date]!['usage'] ?? 0) + item.stockOut;

      // balance dapat digunakan untuk representasi hasil opname
      groupedData[item.date]!['balance'] = item.balance;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem(Colors.blue, 'Pembelian'),
            const SizedBox(width: 12),
            _buildLegendItem(Colors.red, 'Penggunaan'),
            const SizedBox(width: 12),
            _buildLegendItem(Colors.amber, 'Saldo'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: groupedData.entries.map((entry) {
              final date = entry.key;
              final values = entry.value;

              // Find max value for scaling
              final maxValue = [values['purchase'] ?? 0, values['usage'] ?? 0, values['balance'] ?? 0].reduce((a, b) => a > b ? a : b);

              // Scale heights (max height 200), avoid division by zero
              final purchaseHeight = maxValue > 0 ? ((values['purchase'] ?? 0) / maxValue) * 200 : 0;
              final usageHeight = maxValue > 0 ? ((values['usage'] ?? 0) / maxValue) * 200 : 0;
              final balanceHeight = maxValue > 0 ? ((values['balance'] ?? 0) / maxValue) * 200 : 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildBar(purchaseHeight, Colors.blue),
                    const SizedBox(height: 2),
                    _buildBar(usageHeight, Colors.red),
                    const SizedBox(height: 2),
                    _buildBar(balanceHeight, Colors.amber),
                    const SizedBox(height: 8),
                    AppText(
                      date,
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

  Widget _buildBar(num height, Color color) {
    return Container(
      width: 10,
      height: height.toDouble(),
      color: color,
    );
  }
}

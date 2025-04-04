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

    // Group data by date and calculate totals
    final Map<String, Map<String, double>> groupedData = {};

    for (var item in data) {
      if (item.date == null) continue;

      if (!groupedData.containsKey(item.date)) {
        groupedData[item.date!] = {
          'purchase': 0,
          'usage': 0,
          'opname': 0,
        };
      }

      if (item.type == 'purchase' && item.quantity != null) {
        groupedData[item.date!]!['purchase'] = (groupedData[item.date!]!['purchase'] ?? 0) + item.quantity!;
      } else if (item.type == 'usage' && item.quantity != null) {
        // Usage is typically negative, but we store the absolute value for the chart
        groupedData[item.date!]!['usage'] = (groupedData[item.date!]!['usage'] ?? 0) + item.quantity!.abs();
      } else if (item.type == 'opname' && item.quantity != null) {
        groupedData[item.date!]!['opname'] = (groupedData[item.date!]!['opname'] ?? 0) + item.quantity!.abs();
      }
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
            _buildLegendItem(Colors.amber, 'Stock Opname'),
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
              final maxValue = [values['purchase'] ?? 0, values['usage'] ?? 0, values['opname'] ?? 0].reduce((a, b) => a > b ? a : b);

              // Scale heights (max height 200), avoid division by zero
              final purchaseHeight = maxValue > 0 ? ((values['purchase'] ?? 0) / maxValue) * 200 : 0;
              final usageHeight = maxValue > 0 ? ((values['usage'] ?? 0) / maxValue) * 200 : 0;
              final opnameHeight = maxValue > 0 ? ((values['opname'] ?? 0) / maxValue) * 200 : 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildBar(purchaseHeight, Colors.blue),
                    const SizedBox(height: 2),
                    _buildBar(usageHeight, Colors.red),
                    const SizedBox(height: 2),
                    _buildBar(opnameHeight, Colors.amber),
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

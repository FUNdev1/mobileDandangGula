import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/stock_alert_model.dart';
import '../layout/app_card.dart';
import '../layout/app_layout.dart';
import '../text/app_text.dart';

class StockAlertTable extends StatelessWidget {
  final String title;
  final List<StockAlert> stockAlerts;
  final VoidCallback onViewAll;

  const StockAlertTable({
    super.key,
    required this.title,
    required this.stockAlerts,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: title,
      action: TextButton(
        onPressed: onViewAll,
        child: Row(
          children: [
            AppText(
              'Lihat lainya',
              style: TextStyle(color: AppColors.primary),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
      child: Column(
        children: stockAlerts.map((alert) {
          return Column(
            children: [
              _buildStockAlertItem(alert, stockAlerts.indexOf(alert)),
              if (alert != stockAlerts.last) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStockAlertItem(StockAlert alert, int index) {
    // Daftar warna untuk digunakan secara random berdasarkan index
    final List<Color> pillColors = [
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    // Pilih warna berdasarkan index
    Color pillColor = pillColors[index % pillColors.length];
    String pillText = alert.name;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  alert.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: pillColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: pillColor),
                  ),
                  child: AppText(
                    pillText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: pillColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  (alert.stock).toString(),
                  style: AppTextStyles.bodySmall,
                ),
                AppText(
                  alert.unitName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80 * alert.alertLevel,
                    decoration: BoxDecoration(
                      color: alert.alertLevel < 0.3 ? AppColors.error : AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

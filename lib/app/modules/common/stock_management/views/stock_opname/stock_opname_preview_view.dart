import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../core/utils.dart';
import '../../../../../global_widgets/alert/app_snackbar.dart';
import '../../controllers/stock_management_controller.dart';

class StockOpnamePreviewView extends StatelessWidget {
  final StockManagementController controller = Get.find<StockManagementController>();
  final List<Map<String, dynamic>> stockData;

  StockOpnamePreviewView({super.key, required this.stockData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leadingWidth: 150,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Row(
            children: [
              SizedBox(width: 12),
              SvgPicture.asset(
                AppIcons.arrowLeft,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 10),
              Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Preview - Stok Opname',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () => _confirmStockOpname(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B9851),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Lanjutkan'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView(
              children: _buildCategorySections(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Nama Bahan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Satuan Kemasan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Stok Saat ini',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Stok Fisik',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Selisih',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategorySections() {
    // Group items by category
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var item in stockData) {
      final category = item['category'] ?? 'Uncategorized';
      if (!groupedData.containsKey(category)) {
        groupedData[category] = [];
      }
      groupedData[category]!.add(item);
    }

    // Build a section for each category
    List<Widget> sections = [];
    groupedData.forEach((category, items) {
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color(0xFFF3F4F6),
              child: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            ...items.map((item) => _buildItemRow(
                  item['name'] ?? '',
                  item['unit'] ?? '',
                  item['currentStock']?.toString() ?? '0',
                  item['physicalStock']?.toString() ?? '0',
                  item['difference']?.toString() ?? '0',
                )),
          ],
        ),
      );
    });

    return sections;
  }

  Widget _buildItemRow(String name, String unit, String currentStock, String physicalStock, String difference) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(name),
          ),
          Expanded(
            child: Text(unit),
          ),
          Expanded(
            child: Text(currentStock),
          ),
          Expanded(
            child: Text(physicalStock),
          ),
          Expanded(
            child: Text(difference),
          ),
        ],
      ),
    );
  }

  void _confirmStockOpname(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Setelah dilanjutkan anda tidak dapat mengubahnya',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pastikan jumlah stok sudah sesuai.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm Button
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();

                        // Transform stockData into the format needed for API
                        List<Map<String, dynamic>> apiData = stockData
                            .map((item) => {
                                  'id': item['id'],
                                  'stok': item['physicalStock'] ?? 0,
                                  'selisih': item['difference'] ?? 0,
                                })
                            .toList();

                        // Call API to save stock opname
                        final res = await controller.stockManagementRepository.recordStockOpname(
                          apiData,
                        );
                        if (res['success'] == true) {
                          Get.back(result: true);
                          Get.back(result: true);
                        } else {
                          Get.back();
                        }
                        AppSnackBar.success(message: res["message"] ?? "");
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1B9851),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Lanjutkan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

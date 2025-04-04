import 'package:dandang_gula/app/config/theme/app_colors.dart';
import 'package:dandang_gula/app/core/utils.dart';
import 'package:dandang_gula/app/global_widgets/input/app_dropdown_field.dart';
import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../data/repositories/stock_management_repository.dart';
import '../../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../../routes/app_routes.dart';

class StockDetailView extends StatefulWidget {
  final String stockId;

  const StockDetailView({super.key, required this.stockId});

  @override
  State<StockDetailView> createState() => _StockDetailViewState();
}

class _StockDetailViewState extends State<StockDetailView> {
  final StockManagementRepository _repository = Get.find<StockManagementRepository>();
  bool _isLoading = true;
  Map<String, dynamic>? _stockDetail;
  String selectedValue = '';
  List<Map<String, dynamic>> _stockHistory = [];

  // Custom tab state
  int _selectedTabIndex = 0;
  final List<String> _tabTitles = ['Semua', 'Stok Masuk', 'Stok Keluar'];
  final List<String> _tabTypes = ['all', 'in', 'out'];

  // Form controllers for adding stock
  final TextEditingController _amountController = TextEditingController();
  bool _showAddStockOverlay = false;
  double _resultProduction = 0.0;
  double _stockPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStockDetail();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadStockDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch stock detail using the endpoint
      final response = await _repository.getStockDetail(widget.stockId);

      if (response['status'] == true && response['data'] != null) {
        setState(() {
          _stockDetail = response['data'];

          // Mock stock history data - in a real implementation, you would fetch this from an API
          _stockHistory = [
            {
              'date': '2/4/2025 13:00',
              'type': 'usage',
              'description': 'Penjualan\nID Pesanan #1123345',
              'quantity': -400,
              'unit': _stockDetail?['uom'] ?? 'gram',
            },
            {
              'date': '2/4/2025 13:00',
              'type': 'usage',
              'description': 'Penjualan\nID Pesanan #1123345',
              'quantity': -400,
              'unit': _stockDetail?['uom'] ?? 'gram',
            },
            {
              'date': '2/4/2025 13:00',
              'type': 'usage',
              'description': 'Penjualan\nID Pesanan #1123345',
              'quantity': -400,
              'unit': _stockDetail?['uom'] ?? 'gram',
            },
            {
              'date': '2/4/2025 13:00',
              'type': 'purchase',
              'description': 'Pembelian\nDiinput oleh Firman Arivianto',
              'quantity': 1000,
              'unit': _stockDetail?['uom'] ?? 'gram',
            },
            {
              'date': '2/4/2025 13:00',
              'type': 'usage',
              'description': 'Penjualan\nID Pesanan #1123345',
              'quantity': -400,
              'unit': _stockDetail?['uom'] ?? 'gram',
            },
            {
              'date': '2/4/2025 13:00',
              'type': 'purchase',
              'description': 'Pembelian\nDiinput oleh Firman Arivianto',
              'quantity': 1000,
              'unit': _stockDetail?['uom'] ?? 'gram',
            },
          ];

          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load stock detail');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppSnackBar.error(message: 'Gagal memuat detail stok: $e');
    }
  }

  void _toggleAddStockOverlay() {
    setState(() {
      _showAddStockOverlay = !_showAddStockOverlay;
      if (!_showAddStockOverlay) {
        _amountController.clear();
        _resultProduction = 0.0;
        _stockPrice = 0.0;
      }
    });
  }

  void _updateProductionValues(String value) {
    if (value.isEmpty) {
      setState(() {
        _resultProduction = 0.0;
        _stockPrice = 0.0;
      });
      return;
    }

    final amount = double.tryParse(value) ?? 0.0;
    final recipeResult = _stockDetail?['result_per_recipe'] ?? 1000.0;
    final price = _stockDetail?['price'] ?? 0.0;

    setState(() {
      _resultProduction = amount * (recipeResult / 1.0);
      _stockPrice = amount * price;
    });
  }

  Future<void> _addStock() async {
    try {
      if (_amountController.text.isEmpty) {
        AppSnackBar.error(message: 'Jumlah stok harus diisi');
        return;
      }

      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        AppSnackBar.error(message: 'Jumlah stok harus lebih dari 0');
        return;
      }

      // For semifinished items, use production endpoint
      if (_stockDetail?['type'] == 'semifinished') {
        final response = await _repository.recordStockUsage(widget.stockId, amount.toInt(), "Produksi");

        if (response['success'] == true) {
          AppSnackBar.success(message: 'Stok berhasil ditambahkan');
          _toggleAddStockOverlay();
          _loadStockDetail(); // Reload data after adding stock
        } else {
          throw Exception(response['message'] ?? 'Gagal menambahkan stok');
        }
      } else {
        // For raw items, use purchase endpoint
        final response = await _repository.recordStockPurchase(widget.stockId, amount.toInt(), _stockPrice > 0 ? _stockPrice : amount * 10000);

        if (response['success'] == true) {
          AppSnackBar.success(message: 'Stok berhasil ditambahkan');
          _toggleAddStockOverlay();
          _loadStockDetail();
        } else {
          throw Exception(response['message'] ?? 'Gagal menambahkan stok');
        }
      }
    } catch (e) {
      AppSnackBar.error(message: 'Gagal menambahkan stok: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        leadingWidth: 200,
        automaticallyImplyLeading: false,
        leading: !_isLoading
            ? Row(
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.back(closeOverlays: true),
                    child: SvgPicture.asset(
                      AppIcons.close,
                      height: 24,
                      width: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  AppText(
                    _stockDetail?["stock_name"] ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.STOCK_MANAGEMENT_EDIT,
                      arguments: {
                        "type": _stockDetail?["type"],
                        "item": _stockDetail,
                      },
                    ),
                    child: SvgPicture.asset(
                      AppIcons.edit,
                      height: 24,
                      width: 24,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              )
            : null,
        actions: [
          if (!_isLoading && !_showAddStockOverlay)
            GestureDetector(
              onTap: () => _showDeleteConfirmation(),
              child: SvgPicture.asset(
                AppIcons.trashCan,
                height: 24,
                width: 24,
                color: Colors.white,
              ),
            ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _stockDetail == null
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : _buildContent(),

          // Add stock overlay
          if (_showAddStockOverlay)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              right: 0,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Material(
                elevation: 4,
                child: _buildAddStockOverlay(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStockHeader(),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Riwayat Stok",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(Size(200, 40)),
                        child: AppDropdownField(
                          hint: "Hari ini",
                          items: [],
                          selectedValue: selectedValue,
                          onChanged: (val) {
                            setState(() {
                              selectedValue = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCustomTabs(),
              ],
            ),
          ),
          _buildStockHistoryContent(),
        ],
      ),
    );
  }

  Widget _buildAddStockOverlay() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tambah Stok',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: _toggleAddStockOverlay,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catat Pembelian Stok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Amount field
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Jumlah yang mau ditambahkan ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: _updateProductionValues,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '1 Resep = 1000 gram',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Production result
                  Text(
                    'Hasil Produksi',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      children: [
                        Text(
                          _resultProduction > 0 ? '${_resultProduction.toStringAsFixed(0)} ${_stockDetail?['uom'] ?? 'gram'}' : '-',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Price section
                  Text(
                    'Harga stok',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Rp0',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _toggleAddStockOverlay,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF39AC7E)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF39AC7E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _addStock,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Color(0xFF39AC7E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(
          _tabTitles.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == index ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    _tabTitles[index],
                    style: TextStyle(
                      color: _selectedTabIndex == index ? Colors.blue : Colors.grey,
                      fontWeight: _selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockHeader() {
    final stockValue = _stockDetail?['stock'] ?? '0';
    final stockUnit = _stockDetail?['uom'] ?? '';
    final stockPrice = _stockDetail?['price'] ?? 0;
    final isSemiFinished = _stockDetail?['type'] == 'semi-finished';
    final numberOfIngredients = isSemiFinished ? (_stockDetail?['todo'] ?? 0) : 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      color: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Stok Saat ini",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              stockValue.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              stockUnit,
                              style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Harga Saat ini",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Rp${stockPrice.toString()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSemiFinished)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jumlah Bahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            numberOfIngredients.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (isSemiFinished)
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: _toggleAddStockOverlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.secondary,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 4),
                        Text('Tambah Stok'),
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

  Widget _buildStockHistoryContent() {
    // Filter the history based on selected tab
    final filteredHistory = _stockHistory.where((item) {
      final type = _tabTypes[_selectedTabIndex];
      if (type == 'all') return true;
      if (type == 'in') return item['quantity'] > 0;
      if (type == 'out') return item['quantity'] < 0;
      return false;
    }).toList();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Tanggal",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Deskripsi Penggunaan",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Quantity",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          filteredHistory.isEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      "Tidak ada data",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredHistory.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredHistory[index];
                    final isPositive = item['quantity'] > 0;

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['date'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPositive ? 'Stok Masuk' : 'Stok Keluar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isPositive ? Colors.green : Colors.red,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  item['description'].toString().split('\n')[0],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                if (item['description'].toString().contains('\n'))
                                  Text(
                                    item['description'].toString().split('\n')[1],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              isPositive ? "+${item['quantity']} ${item['unit']}" : "${item['quantity']} ${item['unit']}",
                              style: TextStyle(
                                color: isPositive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
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

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus bahan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              _deleteStock();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteStock() async {
    try {
      final response = await _repository.deleteInventoryItem(widget.stockId);

      if (response['success'] == true) {
        Get.back(); // Return to previous screen
        AppSnackBar.success(message: 'Bahan berhasil dihapus');
      } else {
        AppSnackBar.error(message: response['message'] ?? 'Gagal menghapus bahan');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Gagal menghapus bahan: $e');
    }
  }
}

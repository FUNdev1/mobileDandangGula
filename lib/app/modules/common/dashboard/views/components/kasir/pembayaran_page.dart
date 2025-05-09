import 'package:dandang_gula/app/global_widgets/input/app_switch_field.dart';
import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../../global_widgets/buttons/icon_button.dart';
import '../../../../../../global_widgets/buttons/toogle_button.dart';
import '../../../../../../global_widgets/text/app_text.dart';
import '../../../../../../core/utils/theme/app_colors.dart';
import '../../../../../../core/utils/utils.dart';

class PembayaranPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;

  const PembayaranPage({Key? key, required this.selectedItems}) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  // Payment method selection
  String selectedPaymentMethod = 'Tunai';

  // Controllers
  final TextEditingController uangPasController = TextEditingController(text: '50000');
  final TextEditingController lainnyaController = TextEditingController();
  final List<TextEditingController> notesControllers = [];

  // State variables
  bool isLainnyaSelected = false;
  bool isProcessingPayment = false;
  bool isCompliment = false;

  @override
  void initState() {
    super.initState();
    // Initialize notes controllers for each item
    for (var item in widget.selectedItems) {
      notesControllers.add(TextEditingController(text: item['notes'] ?? ''));
    }
  }

  @override
  void dispose() {
    uangPasController.dispose();
    lainnyaController.dispose();
    for (var controller in notesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Calculate totals
  double get subtotal => widget.selectedItems.fold(0, (sum, item) => sum + (double.tryParse(item['price'].toString().replaceAll('Rp ', '').replaceAll(',', '')) ?? 0) * (item['quantity'] ?? 1));

  double get tax => subtotal * 0.003; // 0.3% tax

  double get total => subtotal + tax;

  double get cashAmount {
    if (selectedPaymentMethod != 'Tunai') return 0;

    if (isLainnyaSelected) {
      return double.tryParse(lainnyaController.text.replaceAll(',', '')) ?? 0;
    } else {
      return double.tryParse(uangPasController.text.replaceAll(',', '')) ?? 0;
    }
  }

  double get change => cashAmount - total;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            leading: AppIconButton(
              icon: AppIcons.close,
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconColor: Colors.white,
            ),
            title: AppText(
              'Pembayaran',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        // Left side - Payment method
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Metode Pembayaran',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Payment method options
                                _buildPaymentOption('Tunai'),
                                _buildPaymentOption('Non Tunai'),
                              ],
                            ),
                          ),
                        ),

                        // Middle section - Payment details
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                selectedPaymentMethod == 'Tunai' ? _buildCashPaymentDetails() : _buildNonCashPaymentDetails(),
                                Spacer(),
                                // Action buttons

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            AppText("Pesanan Komplimen"),
                                            SizedBox(width: 10),
                                            AppToogleButton(
                                              value: isCompliment,
                                              onChanged: (value) {
                                                setState(() {
                                                  isCompliment = value;
                                                });
                                              },
                                              activeColor: const Color(0xFF0F5132),
                                              inactiveColor: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 68,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: Color(0xFFC8C8C8), width: 0.5),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Handle print button click
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        AppIcons.printer,
                                                        height: 16,
                                                        width: 16,
                                                        color: Colors.black,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      AppText("Cetak Bill"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    _processPayment();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                                    color: AppColors.primary,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              AppText(
                                                                "Bayar Sekarang",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              AppText(
                                                                'Rp ${total.toStringAsFixed(0)} (${widget.selectedItems.length} Produk)',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SvgPicture.asset(
                                                          AppIcons.caretRight,
                                                          height: 24,
                                                          width: 24,
                                                          color: Colors.white,
                                                        ),
                                                      ],
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
                                )
                              ],
                            ),
                          ),
                        ),

                        // Right side - Order summary
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rincian Pesanan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Order items
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: widget.selectedItems.length,
                                    itemBuilder: (context, index) {
                                      final item = widget.selectedItems[index];
                                      return _buildOrderItem(item, index);
                                    },
                                  ),
                                ),

                                // Order summary
                                const Divider(),
                                _buildSummaryRow('Sub total', 'Rp ${subtotal.toStringAsFixed(0)}'),
                                _buildSummaryRow('Pajak 0.3%', 'Rp ${tax.toStringAsFixed(0)}'),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Total Tagihan', 'Rp ${total.toStringAsFixed(0)}', isBold: true),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Payment success overlay
              if (isProcessingPayment) _buildPaymentSuccessOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    final isSelected = selectedPaymentMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[200],
          border: Border.all(
            color: isSelected ? const Color(0xFF0F5132) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          method,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF0F5132) : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCashPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uang Pas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: uangPasController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabled: !isLainnyaSelected,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Lainnya',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: lainnyaController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabled: isLainnyaSelected,
          ),
          keyboardType: TextInputType.number,
          onTap: () {
            setState(() {
              isLainnyaSelected = true;
            });
          },
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildNonCashPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Metode Pembayaran Non Tunai',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Non-cash payment options would go here
        const Text('Fitur pembayaran non tunai belum tersedia'),
      ],
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '${item["quantity"]}x',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? 'Item',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppTextField(
                        label: "Notes:",
                        controller: notesControllers[index],
                        hint: 'Notes (opsional)',
                        onFocusChanged: (value) {
                          setState(() {
                            item['notes'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item['price'] ?? 'Rp 0',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSuccessOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Transaksi Berhasil!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSummaryRow('Sub total', 'Rp ${subtotal.toStringAsFixed(0)}'),
              _buildSummaryRow('Pajak 0.3%', 'Rp ${tax.toStringAsFixed(0)}'),
              _buildSummaryRow('Total Tagihan', 'Rp ${total.toStringAsFixed(0)}'),
              const Divider(height: 24),
              _buildSummaryRow('Metode pembayaran', 'CASH'),
              _buildSummaryRow('Jumlah Uang', 'Rp ${cashAmount.toStringAsFixed(0)}'),
              _buildSummaryRow('Kembalian', 'Rp ${change.toStringAsFixed(0)}'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Cetak'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      // Handle print receipt
                    },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {
                        'success': true,
                        'paymentMethod': selectedPaymentMethod,
                        'amount': cashAmount,
                        'change': change,
                        'items': widget.selectedItems,
                      });
                    },
                    child: const Text(
                      'Selesai',
                      style: TextStyle(color: Colors.white),
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

  void _processPayment() {
    // Validate payment
    if (selectedPaymentMethod == 'Tunai' && cashAmount < total) {
      // Show error - insufficient funds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah uang tidak mencukupi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show payment success overlay
    setState(() {
      isProcessingPayment = true;
    });

    // In a real app, you would process the payment with your payment gateway here
  }
}

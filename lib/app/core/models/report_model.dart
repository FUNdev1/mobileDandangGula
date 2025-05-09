// Model untuk data grafik
class ChartData {
  final String label;
  final double value;
  final String? date;

  ChartData({
    required this.label,
    required this.value,
    this.date,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? '',
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      date: json['date'],
    );
  }
}

// Model untuk pendapatan berdasarkan kategori
class CategorySales {
  final String categoryId;
  final String categoryName;
  final double amount;
  final int count;
  final double percentage;

  CategorySales({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.count,
    required this.percentage,
  });

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      count: int.tryParse(json['count'].toString()) ?? 0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0.0,
    );
  }
}

// Model untuk penjualan produk
class ProductSales {
  final String menuId;
  final String menuName;
  final String? categoryName;
  final int quantity;
  final double price;
  final double amount;
  final double percentage;

  ProductSales({
    required this.menuId,
    required this.menuName,
    this.categoryName,
    required this.quantity,
    required this.price,
    required this.amount,
    required this.percentage,
  });

  factory ProductSales.fromJson(Map<String, dynamic> json) {
    return ProductSales(
      menuId: json['menu_id'] ?? '',
      menuName: json['menu_name'] ?? '',
      categoryName: json['category_name'],
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0.0,
    );
  }
}

// Model untuk metode pembayaran
class PaymentMethod {
  final String method;
  final double amount;
  final int count;
  final double percentage;

  PaymentMethod({
    required this.method,
    required this.amount,
    required this.count,
    required this.percentage,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      method: json['method'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      count: int.tryParse(json['count'].toString()) ?? 0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0.0,
    );
  }
}

// Model untuk laporan kasir
class CashierReport {
  final String id;
  final String cashierId;
  final String cashierName;
  final DateTime? openTime;
  final DateTime? closeTime;
  final double initialCapital;
  final double cashIn;
  final double cashOut;
  final double cashSales;
  final double cardSales;
  final double totalSales;
  final int totalOrders;
  final double expectedCash;
  final double? actualCash;
  final double? difference;

  CashierReport({
    required this.id,
    required this.cashierId,
    required this.cashierName,
    this.openTime,
    this.closeTime,
    required this.initialCapital,
    required this.cashIn,
    required this.cashOut,
    required this.cashSales,
    required this.cardSales,
    required this.totalSales,
    required this.totalOrders,
    required this.expectedCash,
    this.actualCash,
    this.difference,
  });

  factory CashierReport.fromJson(Map<String, dynamic> json) {
    DateTime? open;
    if (json['open_time'] != null) {
      try {
        open = DateTime.parse(json['open_time']);
      } catch (_) {}
    }

    DateTime? close;
    if (json['close_time'] != null) {
      try {
        close = DateTime.parse(json['close_time']);
      } catch (_) {}
    }

    return CashierReport(
      id: json['id'] ?? '',
      cashierId: json['cashier_id'] ?? '',
      cashierName: json['cashier_name'] ?? '',
      openTime: open,
      closeTime: close,
      initialCapital: double.tryParse(json['initial_capital'].toString()) ?? 0.0,
      cashIn: double.tryParse(json['cash_in'].toString()) ?? 0.0,
      cashOut: double.tryParse(json['cash_out'].toString()) ?? 0.0,
      cashSales: double.tryParse(json['cash_sales'].toString()) ?? 0.0,
      cardSales: double.tryParse(json['card_sales'].toString()) ?? 0.0,
      totalSales: double.tryParse(json['total_sales'].toString()) ?? 0.0,
      totalOrders: int.tryParse(json['total_orders'].toString()) ?? 0,
      expectedCash: double.tryParse(json['expected_cash'].toString()) ?? 0.0,
      actualCash: json['actual_cash'] != null ? double.tryParse(json['actual_cash'].toString()) : null,
      difference: json['difference'] != null ? double.tryParse(json['difference'].toString()) : null,
    );
  }
}

// Model untuk pendapatan dan pengeluaran
class RevenueExpenseData {
  final String date;
  final double revenue;
  final double expense;
  final double profit;

  RevenueExpenseData({
    required this.date,
    required this.revenue,
    required this.expense,
    required this.profit,
  });

  factory RevenueExpenseData.fromJson(Map<String, dynamic> json) {
    return RevenueExpenseData(
      date: json['date'] ?? '',
      revenue: double.tryParse(json['revenue'].toString()) ?? 0.0,
      expense: double.tryParse(json['expense'].toString()) ?? 0.0,
      profit: double.tryParse(json['profit'].toString()) ?? 0.0,
    );
  }
}

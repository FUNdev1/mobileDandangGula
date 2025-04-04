class StockAlert {
  final String id;
  final String name;
  final double stock;
  final String unitName;
  final double alertLevel;
  final double stockLimit;
  final double gap;

  StockAlert({
    required this.id,
    required this.name,
    required this.stock,
    required this.unitName,
    required this.alertLevel,
    required this.stockLimit,
    required this.gap,
  });

  factory StockAlert.fromJson(Map<String, dynamic> json) {
    return StockAlert(
      id: json['id']?.toString() ?? '',
      name: json['stock_name']?.toString() ?? '',
      stock: _parseDouble(json['stock']),
      unitName: json['uom']?.toString() ?? '',
      alertLevel: 1.0, // Selalu 1.0 untuk progress bar penuh
      stockLimit: _parseDouble(json['stock_limit']),
      gap: _parseDouble(json['gap']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

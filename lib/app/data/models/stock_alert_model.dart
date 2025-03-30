class StockAlert {
  final String id;
  final String name;
  final String category;
  final String? stock;
  final String? amount;
  final double alertLevel;
  final String? imageUrl;
  final String? unitId;
  final String? unitName;
  final double? currentStock;
  final double? minimumStock;

  StockAlert({
    required this.id,
    required this.name,
    required this.category,
    this.stock,
    this.amount,
    required this.alertLevel,
    this.imageUrl,
    this.unitId,
    this.unitName,
    this.currentStock,
    this.minimumStock,
  });

  factory StockAlert.fromJson(Map<String, dynamic> json) {
    // Handle different formats of stock limit API
    double alertLevelValue = 0.0;
    if (json['alert_level'] != null) {
      alertLevelValue = double.parse(json['alert_level'].toString());
    } else if (json['stock_percentage'] != null) {
      alertLevelValue = double.parse(json['stock_percentage'].toString());
    }

    return StockAlert(
      id: json['id'].toString(),
      name: json['name'] as String,
      category: json['category'] as String? ?? '',
      stock: json['stock'] as String?,
      amount: json['amount'] as String?,
      alertLevel: alertLevelValue,
      imageUrl: json['image_url'] as String?,
      unitId: json['unit_id'] as String? ?? json['uom'] as String?,
      unitName: json['unit_name'] as String? ?? json['uom'] as String?,
      currentStock: json['current_stock'] != null ? double.parse(json['current_stock'].toString()) : null,
      minimumStock: json['minimum_stock'] != null
          ? double.parse(json['minimum_stock'].toString())
          : json['limit'] != null
              ? double.parse(json['limit'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      if (stock != null) 'stock': stock,
      if (amount != null) 'amount': amount,
      'alert_level': alertLevel,
      if (imageUrl != null) 'image_url': imageUrl,
      if (unitId != null) 'unit_id': unitId,
      if (unitName != null) 'unit_name': unitName,
      if (currentStock != null) 'current_stock': currentStock,
      if (minimumStock != null) 'minimum_stock': minimumStock,
    };
  }
}

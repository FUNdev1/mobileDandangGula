class InventoryItem {
  final String id;
  final String name;
  final String unit;
  final String category;
  final String type; // 'raw' or 'semi-finished'
  final double currentPrice;
  final int purchases;
  final int sales;
  final int currentStock;
  final int minimumStock;
  final double stockPercentage;

  InventoryItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.category,
    required this.type,
    required this.currentPrice,
    required this.purchases,
    required this.sales,
    required this.currentStock,
    required this.minimumStock,
    required this.stockPercentage,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final double stockLevel = json['minimum_stock'] > 0 ? json['current_stock'] / json['minimum_stock'] : 0.0;

    return InventoryItem(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      category: json['category'],
      type: json['type'],
      currentPrice: double.parse(json['current_price'].toString()),
      purchases: json['purchases'],
      sales: json['sales'],
      currentStock: json['current_stock'],
      minimumStock: json['minimum_stock'],
      stockPercentage: stockLevel > 1.0 ? 1.0 : stockLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'category': category,
      'type': type,
      'current_price': currentPrice,
      'purchases': purchases,
      'sales': sales,
      'current_stock': currentStock,
      'minimum_stock': minimumStock,
    };
  }
}

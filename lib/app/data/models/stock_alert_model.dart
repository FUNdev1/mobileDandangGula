class StockAlert {
  final String id;
  final String name;
  final String category;
  final String stock;
  final String amount;
  final double alertLevel;
  final String? imageUrl;
  final String unitId;
  final String unitName;

  StockAlert({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.amount,
    required this.alertLevel,
    this.imageUrl,
    required this.unitId,
    required this.unitName,
  });

  factory StockAlert.fromJson(Map<String, dynamic> json) {
    return StockAlert(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      stock: json['stock'] as String,
      amount: json['amount'] as String,
      alertLevel: json['alert_level'] as double,
      imageUrl: json['image_url'] as String?,
      unitId: json['unit_id'] as String,
      unitName: json['unit_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'stock': stock,
      'amount': amount,
      'alert_level': alertLevel,
      'image_url': imageUrl,
      'unit_id': unitId,
      'unit_name': unitName,
    };
  }
}
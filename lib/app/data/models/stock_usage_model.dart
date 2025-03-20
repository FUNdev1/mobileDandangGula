class StockUsage {
  final String id;
  final String category;
  final double percentage;
  final String color;
  final int usageCount;
  final double usageAmount;
  final String unitId;
  final String unitName;

  StockUsage({
    required this.id,
    required this.category,
    required this.percentage,
    required this.color,
    this.usageCount = 0,
    this.usageAmount = 0.0,
    this.unitId = '',
    this.unitName = '',
  });

  factory StockUsage.fromJson(Map<String, dynamic> json) {
    return StockUsage(
      id: json['id'] as String,
      category: json['category'] as String,
      percentage: json['percentage'] as double,
      color: json['color'] as String,
      usageCount: json['usage_count'] as int? ?? 0,
      usageAmount: json['usage_amount'] as double? ?? 0.0,
      unitId: json['unit_id'] as String? ?? '',
      unitName: json['unit_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'percentage': percentage,
      'color': color,
      'usage_count': usageCount,
      'usage_amount': usageAmount,
      'unit_id': unitId,
      'unit_name': unitName,
    };
  }
}

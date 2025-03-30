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
      id: json['id'].toString(),
      category: json['category'] as String,
      percentage: json['percentage'] != null ? double.parse(json['percentage'].toString()) : 0.0,
      color: json['color'] as String? ?? '#1B9851',
      usageCount: json['usage_count'] != null ? int.parse(json['usage_count'].toString()) : 0,
      usageAmount: json['usage_amount'] != null ? double.parse(json['usage_amount'].toString()) : 0.0,
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

class CategorySales {
  final String id;
  final String name;
  final double amount;
  final double percentage;
  final String color;

  CategorySales({
    required this.id,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(
      id: json['id'].toString(),
      name: json['name'] as String,
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      percentage: json['percentage'] != null ? double.parse(json['percentage'].toString()) : 0.0,
      color: json['color'] as String? ?? '#1B9851',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'percentage': percentage,
      'color': color,
    };
  }
}

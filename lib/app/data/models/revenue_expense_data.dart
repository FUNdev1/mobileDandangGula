class RevenueExpenseData {
  final DateTime date;
  final double revenue;
  final double expense;

  RevenueExpenseData({
    required this.date,
    required this.revenue,
    required this.expense,
  });

  factory RevenueExpenseData.fromJson(Map<String, dynamic> json) {
    return RevenueExpenseData(
      date: json['date'] is String ? DateTime.parse(json['date'] as String) : (json['date'] is DateTime ? json['date'] as DateTime : DateTime.now()),
      revenue: json['revenue'] != null ? double.parse(json['revenue'].toString()) : 0.0,
      expense: json['expense'] != null ? double.parse(json['expense'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'revenue': revenue,
      'expense': expense,
    };
  }

  double get profit => revenue - expense;
  double get margin => revenue > 0 ? (profit / revenue) * 100 : 0;
}

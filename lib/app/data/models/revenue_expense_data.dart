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
      date: DateTime.parse(json['date'] as String),
      revenue: json['revenue'] as double,
      expense: json['expense'] as double,
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
class StockFlowData {
  final String date;
  final double sales;
  final double purchases;
  final double wastage;

  StockFlowData({
    required this.date,
    required this.sales,
    required this.purchases,
    required this.wastage,
  });

  factory StockFlowData.fromJson(Map<String, dynamic> json) {
    return StockFlowData(
      date: json['date'] as String,
      sales: json['sales'] as double,
      purchases: json['purchases'] as double,
      wastage: json['wastage'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sales': sales,
      'purchases': purchases,
      'wastage': wastage,
    };
  }
}

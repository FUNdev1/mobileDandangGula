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
      sales: json['sales'] != null ? double.parse(json['sales'].toString()) : 0.0,
      purchases: json['purchases'] != null ? double.parse(json['purchases'].toString()) : 0.0,
      wastage: json['wastage'] != null ? double.parse(json['wastage'].toString()) : 0.0,
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

import 'package:meta/meta.dart';

class StockFlowData {
  final String? id;
  final String? stockId;
  final String? stockName;
  final String? type;
  final double? quantity;
  final String? uom;
  final double? price;
  final String? date;
  final String? notes;

  StockFlowData({
    this.id,
    this.stockId,
    this.stockName,
    this.type,
    this.quantity,
    this.uom,
    this.price,
    this.date,
    this.notes,
  });

  factory StockFlowData.fromJson(Map<String, dynamic> json) {
    return StockFlowData(
      id: json['id'],
      stockId: json['stock_id'],
      stockName: json['stock_name'],
      type: json['flow_type'], // purchase, usage, opname, production
      quantity: json['quantity'] != null ? double.parse(json['quantity'].toString()) : null,
      uom: json['uom'],
      price: json['price'] != null ? double.parse(json['price'].toString()) : null,
      date: json['date'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_id': stockId,
      'stock_name': stockName,
      'flow_type': type,
      'quantity': quantity,
      'uom': uom,
      'price': price,
      'date': date,
      'notes': notes,
    };
  }
}

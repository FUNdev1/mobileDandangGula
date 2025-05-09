// Model untuk item pesanan
class OrderItem {
  final String menuId;
  final String? menuName;
  final String? notes;
  final int quantity;
  final double price;
  final double subtotal;
  final String? photoUrl;

  OrderItem({
    required this.menuId,
    this.menuName,
    this.notes,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.photoUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuId: json['menu_id'] ?? '',
      menuName: json['menu_name'],
      notes: json['notes'],
      quantity: int.tryParse(json['qty'].toString()) ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      photoUrl: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'notes': notes,
      'qty': quantity.toString(),
      'price': price.toString(),
      'subtotal': subtotal.toString(),
    };
  }
}

// Model untuk pesanan
class Order {
  final String id;
  final String? invoiceNumber;
  final String customerName;
  final String type; // Dine In, Takeaway, dll
  final double subtotal;
  final double? taxPercentage;
  final double? taxTotal;
  final double? total;
  final String status; // Belum Terbayar, Selesai, Batal
  final List<OrderItem> items;
  final String? paymentMethod;
  final double? paymentNominal;
  final double? change;
  final bool? isCompliment;
  final DateTime? createdAt;
  final String? createdBy;

  Order({
    required this.id,
    this.invoiceNumber,
    required this.customerName,
    required this.type,
    required this.subtotal,
    this.taxPercentage,
    this.taxTotal,
    this.total,
    required this.status,
    required this.items,
    this.paymentMethod,
    this.paymentNominal,
    this.change,
    this.isCompliment,
    this.createdAt,
    this.createdBy,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderItems = <OrderItem>[];
    if (json['menu_order'] != null && json['menu_order'] is List) {
      orderItems = (json['menu_order'] as List).map((item) => OrderItem.fromJson(item)).toList();
    }

    DateTime? createdDate;
    if (json['created_at'] != null) {
      try {
        createdDate = DateTime.parse(json['created_at']);
      } catch (_) {}
    }

    return Order(
      id: json['id'] ?? '',
      invoiceNumber: json['no_nota'],
      customerName: json['customer_name'] ?? '',
      type: json['type'] ?? 'Dine In',
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      taxPercentage: json['tax_percentage'] != null ? double.tryParse(json['tax_percentage'].toString()) : null,
      taxTotal: json['tax_total'] != null ? double.tryParse(json['tax_total'].toString()) : null,
      total: json['total'] != null ? double.tryParse(json['total'].toString()) : null,
      status: json['status'] ?? 'Belum Terbayar',
      items: orderItems,
      paymentMethod: json['payment_method'],
      paymentNominal: json['payment_nominal'] != null ? double.tryParse(json['payment_nominal'].toString()) : null,
      change: json['change'] != null ? double.tryParse(json['change'].toString()) : null,
      isCompliment: json['compliment'] == 1 || json['compliment'] == true,
      createdAt: createdDate,
      createdBy: json['created_by'],
    );
  }
}

// Data untuk pembuat pesanan
class OrderData {
  final String type;
  final String customerName;
  final double subtotal;
  final double? taxPercentage;
  final double? taxTotal;
  final double? total;
  final String? paymentMethod;
  final double? paymentNominal;
  final bool? isCompliment;
  final String status;
  final List<OrderItem> items;

  OrderData({
    required this.type,
    required this.customerName,
    required this.subtotal,
    this.taxPercentage,
    this.taxTotal,
    this.total,
    this.paymentMethod,
    this.paymentNominal,
    this.isCompliment,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'customer_name': customerName,
      'subtotal': subtotal,
      'status': status,
      'menu_order': items.map((item) => item.toJson()).toList(),
    };

    if (taxPercentage != null) {
      data['tax_percentage'] = taxPercentage;
    }

    if (taxTotal != null) {
      data['tax_total'] = taxTotal;
    }

    if (total != null) {
      data['total'] = total;
    }

    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod;
    }

    if (paymentNominal != null) {
      data['payment_nominal'] = paymentNominal;
    }

    if (isCompliment != null) {
      data['compliment'] = isCompliment! ? 1 : 0;
    }

    return data;
  }
}

// Data untuk pembayaran
class PaymentData {
  final String paymentMethod;
  final double paymentNominal;
  final bool isCompliment;

  PaymentData({
    required this.paymentMethod,
    required this.paymentNominal,
    this.isCompliment = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod,
      'payment_nominal': paymentNominal,
      'compliment': isCompliment ? 1 : 0,
    };
  }
}

class Order {
  final String id;
  final String branchId;
  final String orderNumber;
  final String orderDate;
  final String cashierId;
  final String cashierName;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.branchId,
    required this.orderNumber,
    required this.orderDate,
    required this.cashierId,
    required this.cashierName,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];

    if (json.containsKey('items') && json['items'] is List) {
      orderItems = (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList();
    }

    return Order(
      id: json['id'] ?? '',
      branchId: json['branch_id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      orderDate: json['order_date'] ?? '',
      cashierId: json['cashier_id'] ?? '',
      cashierName: json['cashier_name'] ?? '',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      orderStatus: json['order_status'] ?? '',
      items: orderItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'order_number': orderNumber,
      'order_date': orderDate,
      'cashier_id': cashierId,
      'cashier_name': cashierName,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String menuId;
  final String menuName;
  final int quantity;
  final double price;
  final double subtotal;
  final String notes;

  OrderItem({
    required this.menuId,
    required this.menuName,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuId: json['menu_id'] ?? '',
      menuName: json['menu_name'] ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'menu_name': menuName,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
      'notes': notes,
    };
  }
}

class OrderData {
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String notes;

  OrderData({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'notes': notes,
    };
  }
}

class PaymentData {
  final String method;
  final double amount;
  final double change;
  final String notes;

  PaymentData({
    required this.method,
    required this.amount,
    required this.change,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'amount': amount,
      'change': change,
      'notes': notes,
    };
  }
}

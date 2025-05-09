// Model untuk ringkasan kasir
class CashierSummary {
  final double initialCapital;
  final double cashIn;
  final double cashOut;
  final double cardSales;
  final double totalSales;
  final double cashSales;
  final double expectedCash;

  CashierSummary({
    required this.initialCapital,
    required this.cashIn,
    required this.cashOut,
    required this.cardSales,
    required this.totalSales,
    required this.cashSales,
    required this.expectedCash,
  });

  factory CashierSummary.fromJson(Map<String, dynamic> json) {
    return CashierSummary(
      initialCapital: double.tryParse(json['initial_capital'].toString()) ?? 0.0,
      cashIn: double.tryParse(json['cash_in'].toString()) ?? 0.0,
      cashOut: double.tryParse(json['cash_out'].toString()) ?? 0.0,
      cardSales: double.tryParse(json['card_sales'].toString()) ?? 0.0,
      totalSales: double.tryParse(json['total_sales'].toString()) ?? 0.0,
      cashSales: double.tryParse(json['cash_sales'].toString()) ?? 0.0,
      expectedCash: double.tryParse(json['expected_cash'].toString()) ?? 0.0,
    );
  }
}

// Model untuk transaksi kas
class CashTransaction {
  final String id;
  final String type; // In, Out
  final double amount;
  final String description;
  final DateTime? createdAt;
  final String? createdBy;

  CashTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    this.createdAt,
    this.createdBy,
  });

  factory CashTransaction.fromJson(Map<String, dynamic> json) {
    DateTime? createdDate;
    if (json['created_at'] != null) {
      try {
        createdDate = DateTime.parse(json['created_at']);
      } catch (_) {}
    }

    return CashTransaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: double.tryParse(json['nominal'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      createdAt: createdDate,
      createdBy: json['created_by'],
    );
  }
}

// Model untuk detail shift
class ShiftDetail {
  final String id;
  final String openBy;
  final DateTime openAt;
  final double initialCapital;
  final int shiftNumber;
  final List<CashTransaction> cashIn;
  final List<CashTransaction> cashOut;
  final List<ShiftOrder> orders;

  ShiftDetail({
    required this.id,
    required this.openBy,
    required this.openAt,
    required this.initialCapital,
    required this.shiftNumber,
    required this.cashIn,
    required this.cashOut,
    required this.orders,
  });

  factory ShiftDetail.fromJson(Map<String, dynamic> json) {
    DateTime openDate;
    try {
      openDate = DateTime.parse(json['open_at'] ?? DateTime.now().toString());
    } catch (_) {
      openDate = DateTime.now();
    }

    List<CashTransaction> cashInList = [];
    if (json['cash_in'] != null && json['cash_in'] is List) {
      cashInList = (json['cash_in'] as List).map((item) => CashTransaction.fromJson(item)).toList();
    }

    List<CashTransaction> cashOutList = [];
    if (json['cash_out'] != null && json['cash_out'] is List) {
      cashOutList = (json['cash_out'] as List).map((item) => CashTransaction.fromJson(item)).toList();
    }

    List<ShiftOrder> ordersList = [];
    if (json['orders'] != null && json['orders'] is List) {
      ordersList = (json['orders'] as List).map((item) => ShiftOrder.fromJson(item)).toList();
    }

    return ShiftDetail(
      id: json['id'] ?? '',
      openBy: json['open_by'] ?? '',
      openAt: openDate,
      initialCapital: double.tryParse(json['initial_capital'].toString()) ?? 0.0,
      shiftNumber: int.tryParse(json['shift_number'].toString()) ?? 0,
      cashIn: cashInList,
      cashOut: cashOutList,
      orders: ordersList,
    );
  }
}

// Model untuk pesanan dalam shift
class ShiftOrder {
  final String id;
  final String invoiceNumber;
  final String customerName;
  final double total;
  final String paymentMethod;
  final DateTime? createdAt;

  ShiftOrder({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.total,
    required this.paymentMethod,
    this.createdAt,
  });

  factory ShiftOrder.fromJson(Map<String, dynamic> json) {
    DateTime? createdDate;
    if (json['created_at'] != null) {
      try {
        createdDate = DateTime.parse(json['created_at']);
      } catch (_) {}
    }

    return ShiftOrder(
      id: json['id'] ?? '',
      invoiceNumber: json['no_nota'] ?? '',
      customerName: json['customer_name'] ?? '',
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      createdAt: createdDate,
    );
  }
}

// Model untuk staff
class StaffMember {
  final String id;
  final String name;
  final String? photoUrl;
  final String? branchId;
  final String? branchName;
  final String? roleId;
  final String? roleName;

  StaffMember({
    required this.id,
    required this.name,
    this.photoUrl,
    this.branchId,
    this.branchName,
    this.roleId,
    this.roleName,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      roleId: json['role_id'],
      roleName: json['role_name'],
    );
  }
}

// Model untuk presensi
class Attendance {
  final String id;
  final String staffId;
  final String staffName;
  final String? staffPhoto;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String? clockInPhoto;
  final String? clockOutPhoto;
  final String status;

  Attendance({
    required this.id,
    required this.staffId,
    required this.staffName,
    this.staffPhoto,
    this.clockIn,
    this.clockOut,
    this.clockInPhoto,
    this.clockOutPhoto,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    DateTime? inTime;
    if (json['clock_in'] != null) {
      try {
        inTime = DateTime.parse(json['clock_in']);
      } catch (_) {}
    }

    DateTime? outTime;
    if (json['clock_out'] != null) {
      try {
        outTime = DateTime.parse(json['clock_out']);
      } catch (_) {}
    }

    return Attendance(
      id: json['id'] ?? '',
      staffId: json['staff_id'] ?? '',
      staffName: json['staff_name'] ?? '',
      staffPhoto: json['staff_photo'],
      clockIn: inTime,
      clockOut: outTime,
      clockInPhoto: json['clock_in_photo'],
      clockOutPhoto: json['clock_out_photo'],
      status: json['status'] ?? 'Active',
    );
  }
}

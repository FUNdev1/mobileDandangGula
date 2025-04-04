class Branch {
  final String id;
  final String kode;
  final String name;
  final String? address;
  final String? photoUrl;
  final String status;

  // Financial data (untuk dashboard)
  final double income;
  final double cogs;
  final double netProfit;
  final double percentChange;

  Branch({
    required this.id,
    required this.kode,
    required this.name,
    this.address,
    this.photoUrl,
    this.status = 'Active',
    this.income = 0.0,
    this.cogs = 0.0,
    this.netProfit = 0.0,
    this.percentChange = 0.0,
  });

  // Create from JSON
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      kode: json['kode'] as String? ?? '',
      name: json['branch_name'] as String,
      address: json['address'] as String?,
      photoUrl: json['photo'] as String?,
      status: json['status'] as String? ?? 'Active',
      income: json['income'] != null ? double.parse(json['income'].toString()) : 0.0,
      cogs: json['cogs'] != null ? double.parse(json['cogs'].toString()) : 0.0,
      netProfit: json['netProfit'] != null ? double.parse(json['netProfit'].toString()) : 0.0,
      percentChange: json['percentChange'] != null ? double.parse(json['percentChange'].toString()) : 0.0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'name': name,
      if (address != null) 'address': address,
      if (photoUrl != null) 'photo': photoUrl,
      'status': status,
      'income': income,
      'cogs': cogs,
      'netProfit': netProfit,
      'percentChange': percentChange,
    };
  }

  // Create a copy with updates
  Branch copyWith({
    String? id,
    String? kode,
    String? name,
    String? address,
    String? photoUrl,
    String? status,
    double? income,
    double? cogs,
    double? netProfit,
    double? percentChange,
  }) {
    return Branch(
      id: id ?? this.id,
      kode: kode ?? this.kode,
      name: name ?? this.name,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      income: income ?? this.income,
      cogs: cogs ?? this.cogs,
      netProfit: netProfit ?? this.netProfit,
      percentChange: percentChange ?? this.percentChange,
    );
  }

  // For comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Branch && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

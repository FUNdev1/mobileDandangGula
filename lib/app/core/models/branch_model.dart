class Branch {
  final String id;
  final String code;
  final String name;
  final String? address;
  final String? photoUrl;
  final String? status;

  Branch({
    required this.id,
    required this.code,
    required this.name,
    this.address,
    this.photoUrl,
    this.status = 'Active',
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? '',
      code: json['kode'] ?? json['branch_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      photoUrl: json['photo'],
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': code,
      'name': name,
      'address': address ?? '',
      'photo': photoUrl,
      'status': status ?? 'Active',
    };
  }

  Branch copyWith({
    String? id,
    String? code,
    String? name,
    String? address,
    String? photoUrl,
    String? status,
  }) {
    return Branch(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
    );
  }
}

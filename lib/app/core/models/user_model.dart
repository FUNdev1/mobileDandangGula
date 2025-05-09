class User {
  final String id;
  final String name;
  final String username;
  final String? pin;
  final String? photoUrl;
  final String? branchId;
  final String? roleId;
  final String? status;
  final Role? role;
  final Branch? branch;
  final String? createdAt;

  User({
    required this.id,
    required this.name,
    required this.username,
    this.pin,
    this.photoUrl,
    this.branchId,
    this.roleId,
    this.status,
    this.role,
    this.branch,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      pin: json['pin'],
      photoUrl: json['photo'],
      branchId: json['branch_id'] ?? json['branch'],
      roleId: json['role_id'] ?? json['role'],
      status: json['status'],
      role: json['role_data'] != null ? Role.fromJson(json['role_data']) : null,
      branch: json['branch_data'] != null ? Branch.fromJson(json['branch_data']) : null,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'pin': pin,
      'photo': photoUrl,
      'branch_id': branchId,
      'role_id': roleId,
      'status': status,
      'role_data': role?.toJson(),
      'branch_data': branch?.toJson(),
      'created_at': createdAt,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? pin,
    String? photoUrl,
    String? branchId,
    String? roleId,
    String? status,
    Role? role,
    Branch? branch,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      pin: pin ?? this.pin,
      photoUrl: photoUrl ?? this.photoUrl,
      branchId: branchId ?? this.branchId,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
      role: role ?? this.role,
      branch: branch ?? this.branch,
      createdAt: createdAt?? this.createdAt,
    );
  }
}

class Role {
  final String id;
  final String role;

  Role({
    required this.id,
    required this.role,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
    };
  }
}

class Branch {
  final String id;
  final String name;
  final String? address;

  Branch({
    required this.id,
    required this.name,
    this.address,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
}

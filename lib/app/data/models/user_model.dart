// In lib/app/data/models/user_model.dart
class User {
  final String? id;
  final String? name;
  final String? username;
  final String? photoUrl;
  final String? role;
  final String? roleName;
  final String? branchName;
  final String? branchId;
  final String? createdAt;
  final String? password;
  final String? pin;
  final String? status;

  User({
    this.id,
    this.name,
    this.username,
    this.photoUrl,
    this.role,
    this.roleName,
    this.branchName,
    this.branchId,
    this.createdAt,
    this.password,
    this.pin,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      username: json['username'] as String?,
      photoUrl: json['photo'] as String?,
      role: json['role_id'] as String?,
      roleName: json['role_name'] as String?,
      branchName: json['branch_name'] as String?,
      branchId: json['branch_id']?.toString(),
      createdAt: json['created_at'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      if (name != null) 'name': name,
      if (username != null) 'username': username,
    };

    if (id != null) data['id'] = id;
    if (photoUrl != null) data['photo'] = photoUrl;
    if (role != null) data['role'] = role;
    if (roleName != null) data['role_name'] = roleName;
    if (branchId != null) data['branch'] = branchId;
    if (password != null) data['password'] = password;
    if (pin != null) data['pin'] = pin;
    if (status != null) data['status'] = status;

    return data;
  }
}

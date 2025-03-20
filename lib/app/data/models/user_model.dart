class User {
  final int? id;
  final String? name;
  final String? username;
  final String? photoUrl;
  final String? role;
  final String? branchName;
  final int? branchId;
  final String? createdAt;
  final String? password;
  final String? pin;

  User({
    this.id,
    this.name,
    this.username,
    this.photoUrl,
    this.role,
    this.branchName,
    this.branchId,
    this.createdAt,
    this.password,
    this.pin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      photoUrl: json['photo_url'],
      role: json['role'],
      branchName: json['branch_name'],
      branchId: json['branch_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'username': username,
    };

    if (id != null) data['id'] = id;
    if (photoUrl != null) data['photo_url'] = photoUrl;
    if (role != null) data['role'] = role;
    if (branchId != null) data['branch_id'] = branchId;
    if (password != null) data['password'] = password;
    if (pin != null) data['pin'] = pin;

    return data;
  }
}

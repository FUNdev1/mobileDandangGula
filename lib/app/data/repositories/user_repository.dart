import 'dart:math' as math;
import '../../global_widgets/buttons/app_pagination.dart';
import '../models/user_model.dart';

class UserRepository {
  // Mock data for user list
  final List<User> _mockUsers = [
    User(
      id: 1,
      name: 'Natasha Ainz',
      username: 'natasha@example.com',
      role: 'admin',
      branchId: 101,
      branchName: 'Central Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 2,
      name: 'Martha Elbert',
      username: 'martha@example.com',
      role: 'kasir',
      branchId: 101,
      branchName: 'Central Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 3,
      name: 'John Doe',
      username: 'john@example.com',
      role: 'gudang',
      branchId: 102,
      branchName: 'East Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 4,
      name: 'Emily Johnson',
      username: 'emily@example.com',
      role: 'branchmanager',
      branchId: 102,
      branchName: 'East Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 5,
      name: 'Michael Smith',
      username: 'michael@example.com',
      role: 'kasir',
      branchId: 103,
      branchName: 'West Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 6,
      name: 'Sarah Wilson',
      username: 'sarah@example.com',
      role: 'pusat',
      branchId: 101,
      branchName: 'Central Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 7,
      name: 'Robert Brown',
      username: 'robert@example.com',
      role: 'admin',
      branchId: 103,
      branchName: 'West Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 8,
      name: 'Jennifer Davis',
      username: 'jennifer@example.com',
      role: 'kasir',
      branchId: 102,
      branchName: 'East Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 9,
      name: 'Daniel Taylor',
      username: 'daniel@example.com',
      role: 'branchmanager',
      branchId: 103,
      branchName: 'West Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
    User(
      id: 10,
      name: 'Jessica Miller',
      username: 'jessica@example.com',
      role: 'kasir',
      branchId: 101,
      branchName: 'Central Branch',
      photoUrl: '',
      createdAt: DateTime.now().toString(),
    ),
  ];

  // Get paginated and filtered users
  Future<PaginatedResponse<User>> getUsers({
    required int page,
    required int limit,
    String searchQuery = '',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Apply filters
    List<User> filteredUsers = _mockUsers.where((user) {
      // Search by name or email
      final searchMatch = searchQuery.isEmpty || (user.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) || (user.username?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      return searchMatch;
    }).toList();

    // Calculate pagination
    final int total = filteredUsers.length;
    final int totalPages = (total / limit).ceil();

    // Handle case when no results
    if (total == 0) {
      return PaginatedResponse<User>(
        data: [],
        page: page,
        limit: limit,
        total: 0,
        totalPages: 1,
      );
    }

    // Get current page data
    final int startIndex = (page - 1) * limit;
    final int endIndex = math.min(startIndex + limit, total);

    // Handle case when page is out of range
    if (startIndex >= total) {
      return PaginatedResponse<User>(
        data: [],
        page: 1, // Reset to page 1
        limit: limit,
        total: total,
        totalPages: totalPages,
      );
    }

    // Get page slice
    final List<User> pageUsers = filteredUsers.sublist(startIndex, endIndex);

    return PaginatedResponse<User>(
      data: pageUsers,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
    );
  }

  // Get a single user by ID
  Future<User?> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _mockUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new user
  Future<User> addUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate new ID
    final int newId = (_mockUsers.map((u) => u.id ?? 0).reduce(math.max) + 1);

    // Create user with new ID
    final newUser = User(
      id: newId,
      name: user.name,
      username: user.username,
      role: user.role,
      // branchId: user.branchId,
      // branchName: user.branchName,
      photoUrl: user.photoUrl,
    );

    // Add to mock data
    _mockUsers.add(newUser);

    return newUser;
  }

  // Update existing user
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (user.id == null) {
      throw Exception('User ID cannot be null');
    }

    final index = _mockUsers.indexWhere((u) => u.id == user.id);

    if (index == -1) {
      throw Exception('User not found');
    }

    _mockUsers[index] = user;
    return user;
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockUsers.indexWhere((u) => u.id == id);

    if (index == -1) {
      return false;
    }

    _mockUsers.removeAt(index);
    return true;
  }

  // Get distinct branches for filtering
  Future<List<Map<String, dynamic>>> getBranches() async {
    final Set<int> branchIds = {};
    final List<Map<String, dynamic>> branches = [];

    for (var user in _mockUsers) {
      if (user.branchId != null && !branchIds.contains(user.branchId)) {
        branchIds.add(user.branchId!);
        branches.add({
          'id': user.branchId,
          'name': user.branchName ?? 'Unknown Branch',
        });
      }
    }

    return branches;
  }

  // Get available roles for filtering
  List<String> getAvailableRoles() {
    return ['admin', 'kasir', 'gudang', 'pusat', 'branchmanager'];
  }
}

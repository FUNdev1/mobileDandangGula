import 'dart:developer';
import 'package:get/get.dart';
import '../models/menu_model.dart';
import '../services/api_service.dart';

abstract class MenuRepository {
  // Menu Categories
  Future<List<MenuCategory>> getAllCategories();
  Future<Map<String, dynamic>> createCategory(String categoryName);
  Future<Map<String, dynamic>> updateCategory(String id, String categoryName);
  Future<Map<String, dynamic>> deleteCategory(String id);

  // Menu Items
  Future<Map<String, dynamic>> getMenuPage({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String? categoryId,
  });

  Future<Menu?> getMenuDetail(String id);

  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menuData, {String? photoPath});
  Future<Map<String, dynamic>> updateMenu(String id, Map<String, dynamic> menuData, {String? photoPath});
  Future<Map<String, dynamic>> deleteMenu(String id);

  // Menu Cards (for POS view)
  Future<Map<String, dynamic>> getMenuCards({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String sort = '',
    String? categoryId,
  });

  Future<Menu?> getMenuCardDetail(String id);
}

class MenuRepositoryImpl implements MenuRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Menu Categories
  @override
  Future<List<MenuCategory>> getAllCategories() async {
    try {
      final response = await _apiService.get('/menucategory');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((category) => MenuCategory.fromJson(category)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching menu categories: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> createCategory(String categoryName) async {
    try {
      final response = await _apiService.post(
        '/menucategory/create',
        body: {'category_name': categoryName},
      );

      return response;
    } catch (e) {
      log('Error creating menu category: $e');
      return {'success': false, 'message': 'Failed to create menu category: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateCategory(String id, String categoryName) async {
    try {
      final response = await _apiService.put(
        '/menucategory/update/$id',
        body: {'category_name': categoryName},
      );

      return response;
    } catch (e) {
      log('Error updating menu category: $e');
      return {'success': false, 'message': 'Failed to update menu category: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteCategory(String id) async {
    try {
      final response = await _apiService.delete('/menucategory/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting menu category: $e');
      return {'success': false, 'message': 'Failed to delete menu category: $e'};
    }
  }

  // Menu Items
  @override
  Future<Map<String, dynamic>> getMenuPage({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String? categoryId,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'pageSize': pageSize,
      };

      if (categoryId != null && categoryId.isNotEmpty) {
        requestData['category'] = categoryId;
      }

      if (search.isNotEmpty) {
        requestData['search'] = search;
      }

      final response = await _apiService.post('/menu', body: requestData);
      return response;
    } catch (e) {
      log('Error fetching menu page: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  @override
  Future<Menu?> getMenuDetail(String id) async {
    try {
      final response = await _apiService.get('/menu/detail/$id');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return Menu.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      log('Error fetching menu detail: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menuData, {String? photoPath}) async {
    try {
      // Required fields validation
      if (!menuData.containsKey('menu_name') || !menuData.containsKey('price') || !menuData.containsKey('category_id')) {
        return {
          'success': false,
          'message': 'Missing required fields for menu',
        };
      }

      final Map<String, dynamic> requestData = Map<String, dynamic>.from(menuData);

      //print
      log(requestData.toString());

      if (photoPath != null) {
        requestData['photo'] = photoPath;
      }

      final response = await _apiService.post('/menu/create', body: requestData);
      return response;
    } catch (e) {
      log('Error creating menu: $e');
      return {'success': false, 'message': 'Failed to create menu: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateMenu(String id, Map<String, dynamic> menuData, {String? photoPath}) async {
    try {
      final Map<String, dynamic> requestData = Map<String, dynamic>.from(menuData);

      if (photoPath != null) {
        requestData['photo'] = photoPath;
      }

      final response = await _apiService.post('/menu/update/$id', body: requestData);
      return response;
    } catch (e) {
      log('Error updating menu: $e');
      return {'success': false, 'message': 'Failed to update menu: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteMenu(String id) async {
    try {
      final response = await _apiService.delete('/menu/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting menu: $e');
      return {'success': false, 'message': 'Failed to delete menu: $e'};
    }
  }

  // Menu Cards (for POS view)
  @override
  Future<Map<String, dynamic>> getMenuCards({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String sort = '',
    String? categoryId,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'pageSize': pageSize,
        'search': search,
        'sort': sort,
      };

      if (categoryId != null && categoryId.isNotEmpty) {
        requestData['category'] = categoryId;
      }

      final response = await _apiService.post('/menu/card', body: requestData);

      return response;
    } catch (e) {
      log('Error fetching menu cards: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  @override
  Future<Menu?> getMenuCardDetail(String id) async {
    try {
      final response = await _apiService.get('/menu/cardDetail/$id');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return Menu.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      log('Error fetching menu card detail: $e');
      return null;
    }
  }
}

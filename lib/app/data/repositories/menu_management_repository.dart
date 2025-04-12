import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/menu_model.dart';
import '../models/menu_category_model.dart';

abstract class MenuManagementRepository {
  Future<List<MenuCategory>> getMenuCategories();
  Future<Map<String, dynamic>> createMenuCategory(String categoryName);
  Future<Map<String, dynamic>> updateMenuCategory(String id, String categoryName);
  Future<Map<String, dynamic>> deleteMenuCategory(String id);

  Future<Map<String, dynamic>> getMenuList({int page = 1, int pageSize = 10, String search = '', String category = ''});
  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menuData);
  Future<Map<String, dynamic>> updateMenu(String id, Map<String, dynamic> menuData);
  Future<Map<String, dynamic>> deleteMenu(String id);
  Future<Menu> getMenuDetail(String id);
  Future<List<Menu>> getMenuCardList({int page = 1, int pageSize = 10, String search = '', String sort = '', String category = ''});
  Future<Menu> getMenuCardDetail(String id);
  Future<Map<String, dynamic>> getListGroupCategory();
}

class MenuManagementRepositoryImpl implements MenuManagementRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<List<MenuCategory>> getMenuCategories() async {
    try {
      final response = await _apiService.get('/menucategory');

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => MenuCategory.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting menu categories: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> createMenuCategory(String categoryName) async {
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
  Future<Map<String, dynamic>> updateMenuCategory(String id, String categoryName) async {
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
  Future<Map<String, dynamic>> deleteMenuCategory(String id) async {
    try {
      final response = await _apiService.delete('/menucategory/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting menu category: $e');
      return {'success': false, 'message': 'Failed to delete menu category: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> getMenuList({int page = 1, int pageSize = 10, String search = '', String category = ''}) async {
    try {
      final response = await _apiService.post(
        '/menu',
        body: {'page': page, 'pageSize': pageSize, 'search': search, 'category': category},
      );

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return response["data"];
      }

      return {'data': []};
    } catch (e) {
      log('Error getting menu list: $e');
      return {'data': []};
    }
  }

  @override
  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menuData) async {
    try {
      final response = await _apiService.post('/menu/create', body: menuData);
      return response;
    } catch (e) {
      log('Error creating menu: $e');
      return {'success': false, 'message': 'Failed to create menu: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateMenu(String id, Map<String, dynamic> menuData) async {
    try {
      final response = await _apiService.post('/menu/update/$id', body: menuData);
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

  @override
  Future<Menu> getMenuDetail(String id) async {
    try {
      final response = await _apiService.get('/menu/detail/$id');

      if (response is Map && response.containsKey('data')) {
        return Menu.fromJson(response['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      log('Error getting menu detail: $e');
      throw Exception('Failed to get menu detail: $e');
    }
  }

  @override
  Future<List<Menu>> getMenuCardList({int page = 1, int pageSize = 10, String search = '', String sort = '', String category = ''}) async {
    try {
      final response = await _apiService.post(
        '/menu/card',
        body: {'page': page, 'pageSize': pageSize, 'search': search, 'sort': sort, 'category': category},
      );

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => Menu.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting menu card list: $e');
      return [];
    }
  }

  @override
  Future<Menu> getMenuCardDetail(String id) async {
    try {
      final response = await _apiService.get('/menu/cardDetail/$id');

      if (response is Map && response.containsKey('data')) {
        return Menu.fromJson(response['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      log('Error getting menu card detail: $e');
      throw Exception('Failed to get menu card detail: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getListGroupCategory() async {
    try {
      final response = await _apiService.get('/stockgroup/list');

      if (response is Map && response.containsKey('data')) {
        return response["data"];
      }
      return {'success': false, 'message': 'Invalid response format'};
    } catch (e) {
      log('Error getting menu card detail: $e');
      return {'success': false, 'message': 'Failed to get menu card detail: $e'};
    }
  }
}

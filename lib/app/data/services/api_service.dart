import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  late dio.Dio _dio;
  final String baseUrl;
  String? token;

  // Mode development untuk debugging
  final bool devMode = false;

  ApiService({required this.baseUrl}) {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status! < 500,
      ),
    );

    // _dio.interceptors.add(
    //   dio.LogInterceptor(
    //     requestBody: false,
    //     responseBody: false,
    //   ),
    // );
  }

  // Metode untuk set token setelah login
  void setAuthToken(String newToken) {
    token = newToken;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // POST request
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    if (devMode) {
      log('DEV MODE: Melewatkan POST request ke $endpoint');
      await Future.delayed(const Duration(milliseconds: 200));
      return _getMockData(endpoint, body);
    }

    try {
      dynamic data = body;
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Jika ada file, convert ke FormData
      if (body is Map<String, dynamic> && (body.containsKey('files') || body.containsKey('photo'))) {
        final formData = dio.FormData();

        body.forEach((key, value) {
          if (key != 'files' && key != 'photo' && value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });

        // Handle files array jika ada
        if (body.containsKey('files') && body['files'] is List) {
          for (var fileData in body['files']) {
            if (fileData is Map<String, dynamic>) {
              formData.files.add(MapEntry(
                fileData['field'],
                await dio.MultipartFile.fromFile(
                  // Gunakan dio.MultipartFile
                  fileData['path'],
                  filename: fileData['filename'],
                ),
              ));
            }
          }
        }

        // Handle single photo field jika ada
        if (body.containsKey('photo') && body['photo'] != null) {
          String photoPath = body['photo'];
          if (photoPath.isNotEmpty) {
            formData.files.add(MapEntry(
              'photo',
              await dio.MultipartFile.fromFile(
                // Gunakan dio.MultipartFile
                photoPath,
                filename: photoPath.split('/').last,
              ),
            ));
          }
        }
        data = formData;
        headers.remove('Content-Type');
      }

      // if (data is dio.FormData) {
      //   log('Sending FormData with fields: ${data.fields}');
      //   if (data.files.isNotEmpty) {
      //     log('Files: ${data.files.map((f) => f.key).toList()}');
      //   }
      // }

      final response = await _dio.post(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
      );

      return _processResponse(response);
    } catch (e) {
      log('POST Error: $e');
      if (e is dio.DioException) {
        // Gunakan dio.DioException
        _handleDioError(e);
      }
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    if (devMode) {
      log('DEV MODE: Melewatkan GET request ke $endpoint');
      await Future.delayed(const Duration(milliseconds: 200));
      return _getMockData(endpoint, queryParams);
    }

    try {
      // Fixed the syntax error in this line
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      return _processResponse(response);
    } catch (e) {
      log('GET Error: $e');
      if (e is dio.DioException) {
        _handleDioError(e);
      }
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {dynamic body, Map<String, dynamic>? queryParams}) async {
    if (devMode) {
      log('DEV MODE: Melewatkan PUT request ke $endpoint');
      await Future.delayed(const Duration(milliseconds: 200));
      return _getMockData(endpoint, body);
    }

    try {
      dynamic data = body;

      // Jika ada file, convert ke FormData (sama seperti di post)
      if (body is Map<String, dynamic> && (body.containsKey('files') || body.containsKey('photo'))) {
        final formData = dio.FormData();

        body.forEach((key, value) {
          if (key != 'files' && key != 'photo' && value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });

        // Handle files array jika ada
        if (body.containsKey('files') && body['files'] is List) {
          for (var fileData in body['files']) {
            if (fileData is Map<String, dynamic>) {
              formData.files.add(MapEntry(
                fileData['field'],
                await dio.MultipartFile.fromFile(
                  fileData['path'],
                  filename: fileData['filename'],
                ),
              ));
            }
          }
        }

        // Handle single photo field jika ada
        if (body.containsKey('photo') && body['photo'] != null) {
          String photoPath = body['photo'];
          if (photoPath.isNotEmpty) {
            formData.files.add(MapEntry(
              'photo',
              await dio.MultipartFile.fromFile(
                photoPath,
                filename: photoPath.split('/').last,
              ),
            ));
          }
        }

        data = formData;
      }

      final response = await _dio.put(
        endpoint,
        queryParameters: queryParams,
        data: data,
      );

      return _processResponse(response);
    } catch (e) {
      log('PUT Error: $e');
      if (e is dio.DioException) {
        _handleDioError(e);
      }
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {dynamic body, Map<String, dynamic>? queryParams}) async {
    if (devMode) {
      log('DEV MODE: Melewatkan DELETE request ke $endpoint');
      await Future.delayed(const Duration(milliseconds: 200));
      return _getMockData(endpoint, body ?? queryParams);
    }

    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParams,
      );

      return _processResponse(response);
    } catch (e) {
      log('DELETE Error: $e');
      if (e is dio.DioException) {
        _handleDioError(e);
      }
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  // Process response dan handle errors
// Process response dan handle errors
  dynamic _processResponse(dio.Response response) {
    log('Request Body ${response.requestOptions.uri.path}: ${response.requestOptions.data}');
    log('Response Status Code ${response.requestOptions.uri.path}: ${response.statusCode}');
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      log('Response Body ${response.requestOptions.uri.path}:  ${response.data}');
    }

    final responseBody = response.data;

    // Return response for all status codes between 200-499
    // This lets services handle authentication errors (401) and validation errors properly
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 500) {
      return responseBody;
    } else {
      // For server errors (500+), throw exception with message
      final errorMessage = responseBody is Map && responseBody.containsKey('message') ? responseBody['message'] : 'Terjadi kesalahan pada server';
      throw Exception(errorMessage);
    }
  }

  // Handle Dio specific errors
  void _handleDioError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        throw Exception('Connection timeout. Please check your internet connection.');

      case dio.DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          if (response.statusCode == 401) {
            // Unauthorized - token invalid/expired
            // Bisa tambahkan logic untuk refresh token atau logout
            throw Exception('Session expired. Please login again.');
          } else if (response.data is Map && response.data.containsKey('message')) {
            throw Exception(response.data['message']);
          }
        }
        throw Exception('Server error occurred. Please try again later.');

      case dio.DioExceptionType.cancel:
        throw Exception('Request cancelled');

      case dio.DioExceptionType.connectionError:
        throw Exception('No internet connection');

      default:
        throw Exception('Something went wrong. Please try again.');
    }
  }

  // Mock data untuk development
  // Fungsi mock data tetap dipertahankan untuk mode development
  dynamic _getMockData(String endpoint, [dynamic params]) {
    // Basic mock data patterns based on endpoint structure
    if (endpoint.contains('/branches')) {
      if (endpoint == '/branches') {
        // Return list of branches
        return [
          {
            'id': '1',
            'name': 'Kedai Dandang Gula MT. Haryono',
            'address': 'Jl. MT. Haryono No. 10',
            'phone': '021-1234567',
            'email': 'haryono@dandanggula.com',
            'managerId': '101',
            'managerName': 'Joe Heiden',
            'income': 10000000.0, // Use doubles for numeric values
            'cogs': 45000000.0,
            'netProfit': 5000000.0,
            'percentChange': -9.75,
          },
          {
            'id': '2',
            'name': 'Kedai Dandang Gula Margonda',
            'address': 'Jl. Margonda Raya No. 525',
            'phone': '021-8765432',
            'email': 'margonda@dandanggula.com',
            'managerId': '102',
            'managerName': 'Martha Elbert',
            'income': 12000000.0,
            'cogs': 48000000.0,
            'netProfit': 6000000.0,
            'percentChange': 5.25,
          },
          {
            'id': '3',
            'name': 'Kedai Dandang Gula Sentul',
            'address': 'Jl. Sentul No. 100',
            'phone': '021-9876543',
            'email': 'sentul@dandanggula.com',
            'managerId': '103',
            'managerName': 'John Smith',
            'income': 8000000.0,
            'cogs': 35000000.0,
            'netProfit': 4500000.0,
            'percentChange': 3.42,
          },
        ];
      } else if (endpoint.contains('/branches/') && endpoint.endsWith('/revenue-expense')) {
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
            'revenue': 1500000.0 + (i * 100000.0),
            'expense': 1000000.0 + (i * 50000.0 * (i % 3 == 0 ? 1.2 : 0.8)),
          });
        }

        return data;
      } else if (endpoint.contains('/branches/') && endpoint.contains('/chart')) {
        // This will correctly match endpoints like "/branches/1/chart"
        log('Generating mock data for branch chart: $endpoint');
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'label': '$i',
            'value': 1500000.0 + (i * 100000.0 * (i % 3 == 0 ? 0.8 : 1.2)),
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
          });
        }
        return data;
      }
    } else if (endpoint.contains('/branches/') && endpoint.contains('/revenue')) {
      // Branch revenue data
      // Extract branch ID from the URL
      final branchId = int.tryParse(endpoint.split('/')[2]) ?? 1;

      return {
        'revenue': 1500000.0 * (branchId * 0.2),
        'cogs': 900000.0 * (branchId * 0.15),
        'netProfit': 600000.0 * (branchId * 0.25),
        'growth': 3.5 * (branchId % 3 == 0 ? -1 : 1),
      };
    } else if (endpoint.contains('/dashboard')) {
      if (endpoint == '/dashboard/summary') {
        return {
          'totalIncome': 50000000.0, // Use doubles
          'netProfit': 3000000.0,
          'percentChange': -9.75,
        };
      } else if (endpoint.contains('/dashboard/sales-performance')) {
        // Sales performance data - return as list
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'label': '$i',
            'value': 1500000.0 + (i * 100000.0 * (i % 3 == 0 ? 0.8 : 1.2)), // Use doubles
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
          });
        }
        return data;
      } else if (endpoint.contains('/revenue-chart')) {
        // Return as list for chart data
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'label': 'Jan $i',
            'value': 10000000.0 + (i * 500000.0 * (i % 3 == 0 ? -1 : 1)), // Use doubles
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
          });
        }
        return data;
      } else if (endpoint == '/dashboard/total-revenue') {
        return {
          'revenue': 50000000.0,
        };
      } else if (endpoint == '/dashboard/total-profit') {
        return {
          'profit': 3000000.0,
        };
      } else if (endpoint == '/dashboard/revenue-growth') {
        return {
          'growth': -9.75,
        };
      }
    }
    // Stock Management Mock Data
    else if (endpoint.startsWith('/inventory')) {
      // Inventory items endpoint
      if (endpoint == '/inventory/items') {
        return [
          {
            'id': '1',
            'name': 'Daging Ayam',
            'unit': 'Kg',
            'category': 'Protein',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 2000,
            'stock_percentage': 0.55,
          },
          {
            'id': '2',
            'name': 'Sambal Terasi',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 2000,
            'sales': 1000,
            'current_stock': 1500,
            'minimum_stock': 2000,
            'stock_percentage': 0.75,
          },
          {
            'id': '3',
            'name': 'Telur Ayam',
            'unit': 'Kg',
            'category': 'Protein',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 2000,
            'stock_percentage': 0.55,
          },
          {
            'id': '4',
            'name': 'Susu Sapi',
            'unit': 'Botol',
            'category': 'Minuman',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '5',
            'name': 'Garam',
            'unit': 'Gram',
            'category': 'Bumbu',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1800,
            'current_stock': 200,
            'minimum_stock': 1000,
            'stock_percentage': 0.2,
          },
          {
            'id': '6',
            'name': 'Gula',
            'unit': 'Gram',
            'category': 'Bumbu',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 500,
            'current_stock': 1500,
            'minimum_stock': 5000,
            'stock_percentage': 0.3,
          },
          {
            'id': '7',
            'name': 'Air Mineral',
            'unit': 'Ml',
            'category': 'Minuman',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 500,
            'current_stock': 1500,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '8',
            'name': 'Mayonaise',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 2000,
            'sales': 500,
            'current_stock': 1500,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '9',
            'name': 'Sambal Terasi',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 2000,
            'stock_percentage': 0.55,
          },
          {
            'id': '10',
            'name': 'Bumbu Treng',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 0,
            'sales': 0,
            'current_stock': 1100,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '11',
            'name': 'Meat Hamburg',
            'unit': 'Botol',
            'category': 'Protein',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 0,
            'sales': 0,
            'current_stock': 1100,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
        ];
      }
      // Stock alerts endpoint - disesuaikan dengan model StockAlert yang sudah ada
      else if (endpoint == '/inventory/alerts') {
        return [
          {
            'id': '1',
            'name': 'Lada Bubuk',
            'category': 'Bumbu',
            'stock': 'Bahan',
            'amount': '100 gr',
            'alert_level': 0.23,
            'image_url': null,
            'unit_id': '1',
            'unit_name': 'kg',
          },
          {
            'id': '2',
            'name': 'Santan kelapa',
            'category': 'Bumbu',
            'stock': 'Bahan',
            'amount': '200 ml',
            'alert_level': 0.29,
            'image_url': null,
            'unit_id': '2',
            'unit_name': 'ml',
          },
          {
            'id': '3',
            'name': 'Telur Asin',
            'category': 'Protein',
            'stock': 'Bahan',
            'amount': '5 Butir',
            'alert_level': 0.29,
            'image_url': null,
            'unit_id': '3',
            'unit_name': 'butir',
          },
          {
            'id': '4',
            'name': 'Syrup Chocolate',
            'category': 'Minuman',
            'stock': 'Bahan',
            'amount': '500 ml',
            'alert_level': 0.48,
            'image_url': null,
            'unit_id': '4',
            'unit_name': 'ml',
          },
          {
            'id': '5',
            'name': 'Telur Asin',
            'category': 'Protein',
            'stock': 'Bahan',
            'amount': '5 Butir',
            'alert_level': 0.29,
            'image_url': null,
            'unit_id': '5',
            'unit_name': 'butir',
          },
          {
            'id': '6',
            'name': 'Syrup Chocolate',
            'category': 'Minuman',
            'stock': 'Bahan',
            'amount': '500 ml',
            'alert_level': 0.48,
            'image_url': null,
            'unit_id': '6',
            'unit_name': 'ml',
          },
        ];
      }
      // Stock flow data endpoint
      else if (endpoint == '/inventory/flow') {
        return [
          {'date': '1 Jul', 'sales': 100, 'purchases': 150, 'wastage': 20},
          {'date': '2 Jul', 'sales': 120, 'purchases': 120, 'wastage': 15},
          {'date': '3 Jul', 'sales': 90, 'purchases': 180, 'wastage': 25},
          {'date': '4 Jul', 'sales': 110, 'purchases': 100, 'wastage': 10},
          {'date': '5 Jul', 'sales': 130, 'purchases': 90, 'wastage': 18},
          {'date': '6 Jul', 'sales': 95, 'purchases': 140, 'wastage': 22},
          {'date': '7 Jul', 'sales': 115, 'purchases': 130, 'wastage': 12},
        ];
      }
      // Stock usage by group endpoint - disesuaikan dengan model StockUsage yang sudah ada
      else if (endpoint == '/inventory/usage-by-group') {
        return [
          {'id': '1', 'category': 'Protein', 'percentage': 35.0, 'color': '#E94235', 'usage_count': 120, 'usage_amount': 325.5, 'unit_id': '1', 'unit_name': 'kg'},
          {'id': '2', 'category': 'Bumbu', 'percentage': 25.0, 'color': '#4285F4', 'usage_count': 85, 'usage_amount': 156.2, 'unit_id': '2', 'unit_name': 'kg'},
          {'id': '3', 'category': 'Sayuran', 'percentage': 20.0, 'color': '#34A853', 'usage_count': 65, 'usage_amount': 95.8, 'unit_id': '3', 'unit_name': 'kg'},
          {'id': '4', 'category': 'Minuman', 'percentage': 15.0, 'color': '#FBBC05', 'usage_count': 42, 'usage_amount': 185.3, 'unit_id': '4', 'unit_name': 'liter'},
          {'id': '5', 'category': 'Lainnya', 'percentage': 5.0, 'color': '#9AA0A6', 'usage_count': 18, 'usage_amount': 42.5, 'unit_id': '5', 'unit_name': 'kg'},
        ];
      }
      // Get specific inventory item
      else if (endpoint.startsWith('/inventory/items/') && endpoint.split('/').length == 4) {
        String id = endpoint.split('/').last;
        // Return a single item based on ID
        return {
          'id': id,
          'name': 'Item $id',
          'unit': 'Kg',
          'category': 'Bumbu',
          'type': id.contains('1') ? 'raw' : 'semi-finished',
          'current_price': 100000,
          'purchases': 1000,
          'sales': 800,
          'current_stock': 1200,
          'minimum_stock': 1000,
          'stock_percentage': 1.2,
        };
      }
      // For create, update, and delete operations
      else if (endpoint == '/inventory/purchases') {
        return {'success': true, 'message': 'Stock purchase recorded successfully'};
      } else if (endpoint == '/inventory/usage') {
        return {'success': true, 'message': 'Stock usage recorded successfully'};
      }
    }

    // Default fallback mock data for any other endpoint
    return {'success': true, 'message': 'Mock data for endpoint: $endpoint', 'data': []};
  }
}

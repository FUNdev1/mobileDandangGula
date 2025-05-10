import 'dart:convert';
import 'dart:io';
import 'package:dandang_gula/app/core/utils/constant/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

abstract class ApiService {
  String? get token;
  void setToken(String? token);

  Future<dynamic> get(String endpoint, {dynamic queryParams});
  Future<dynamic> post(String endpoint, {dynamic body});
  Future<dynamic> put(String endpoint, {dynamic body});
  Future<dynamic> delete(String endpoint);

  // Metode untuk upload file
  Future<dynamic> postWithFile(String endpoint, String? filePath, {Map<String, dynamic>? fields});
}

class ApiServiceImpl implements ApiService {
  // Base URL API
  final String baseUrl = AppConstants.baseUrl;

  // Token untuk autentikasi
  String? _token;

  // Dio instance
  late final Dio _dio;

  ApiServiceImpl({String? token}) : _token = token {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));

    // Tambahkan interceptor untuk header
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Tambahkan header standar
        options.headers['Accept'] = 'application/json';

        // Tambahkan token jika tersedia
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        debugPrint("#####REQUEST#####");
        debugPrint('Request:(url:${options.uri})\nData : ${options.data}\nQuery Param : ${options.queryParameters}');
        debugPrint("#################");

        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("#####RESPONSE#####");

        // Tampilkan status code
        debugPrint('Response status: ${response.statusCode}');

        // Jika status code sukses (< 400), tampilkan data response
        if (response.statusCode != null && response.statusCode! < 400) {
          debugPrint('Response data: ${response.data}');
        }
        // Jika status code error (≥ 400), tampilkan pesan error dengan warna merah
        else if (response.statusCode != null && response.statusCode! >= 400) {
          debugPrint('\x1B[31mERROR (${response.statusCode}): ${response.data}\x1B[0m');
        }

        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Tampilkan error dengan warna merah
        debugPrint('\x1B[31m#####ERROR#####\x1B[0m');
        debugPrint('\x1B[31mError type: ${e.type}\x1B[0m');
        if (e.response != null) {
          debugPrint('\x1B[31mStatus code: ${e.response?.statusCode}\x1B[0m');
          debugPrint('\x1B[31mError data: ${e.response?.data}\x1B[0m');
        } else {
          debugPrint('\x1B[31mError message: ${e.message}\x1B[0m');
        }
        debugPrint('\x1B[31m###############\x1B[0m');

        return handler.next(e);
      },
    ));
  }

  @override
  String? get token => _token;

  @override
  void setToken(String? token) {
    _token = token;
  }

  // Metode untuk memproses response dan error
  dynamic _processResponse(Response response) {
    if (response.data == null || (response.data is String && response.data.isEmpty)) {
      return {};
    }
    // print(token);

    return response.data;
  }

  // Metode untuk menangani error
  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Error dengan response dari server
        try {
          final errorData = error.response!.data;
          throw ApiException(
            statusCode: error.response!.statusCode,
            message: errorData['message'] ?? 'Unknown error',
            errors: errorData['errors'],
          );
        } catch (e) {
          throw ApiException(
            statusCode: error.response!.statusCode,
            message: 'Request failed with status: ${error.response!.statusCode}',
          );
        }
      } else {
        // Error tanpa response (koneksi, timeout, dll)
        throw ApiException(
          message: error.message ?? 'Connection error',
        );
      }
    }

    // Error lainnya
    if (error is ApiException) throw error;
    throw ApiException(message: error.toString());
  }

  @override
  Future<dynamic> get(String endpoint, {dynamic queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
      );

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
      );

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> postWithFile(String endpoint, String? filePath, {Map<String, dynamic>? fields}) async {
    try {
      // Buat FormData
      final formData = FormData();

      // Periksa apakah file ada
      if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (!await file.exists()) {
          throw ApiException(message: 'File not found: $filePath');
        }
        // Tambahkan file
        final fileName = path.basename(filePath);
        formData.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              filePath,
              filename: fileName,
            ),
          ),
        );
      }

      // Tambahkan fields jika ada
      if (fields != null) {
        fields.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });
      }

      // Kirim request
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }
}

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic errors;

  ApiException({
    this.statusCode,
    required this.message,
    this.errors,
  });

  @override
  String toString() {
    return 'ApiException: $message (${statusCode ?? "unknown"})';
  }
}

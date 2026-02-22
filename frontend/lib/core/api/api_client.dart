import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.getToken,
  });

  final String baseUrl;
  final Future<String?> Function()? getToken;

  Uri _uri(String path, [Map<String, String>? queryParams]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
  }

  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (getToken != null) {
      final token = await getToken!();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final res = await http.get(
        _uri(path, queryParams),
        headers: await _headers(),
      );
      return _handleResponse<T>(res, fromJson);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final res = await http.post(
        _uri(path),
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse<T>(res, fromJson);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> uploadFile<T>(
    String path,
    File file, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final req = http.MultipartRequest('POST', _uri(path));
      final token = getToken != null ? await getToken!() : null;
      if (token != null && token.isNotEmpty) {
        req.headers['Authorization'] = 'Bearer $token';
      }
      req.files.add(await http.MultipartFile.fromPath('file', file.path));
      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);
      final decoded = res.body.isNotEmpty
          ? (jsonDecode(res.body) as Map<String, dynamic>? ?? {})
          : <String, dynamic>{};
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = fromJson != null ? fromJson(decoded) : decoded as T;
        return ApiResponse.success(data);
      }
      return ApiResponse.error(
        decoded['error'] as String? ?? 'Upload failed',
        statusCode: res.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response res,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final decoded = res.body.isNotEmpty
        ? (jsonDecode(res.body) as Map<String, dynamic>? ?? {})
        : <String, dynamic>{};

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = fromJson != null ? fromJson(decoded) : decoded as T;
      return ApiResponse.success(data);
    }
    final msg = decoded['error'] as String? ?? 'Unknown error';
    return ApiResponse.error(msg, statusCode: res.statusCode);
  }
}

class ApiResponse<T> {
  const ApiResponse._({this.data, this.error, this.statusCode});

  factory ApiResponse.success(T data) => ApiResponse._(data: data);

  factory ApiResponse.error(String error, {int? statusCode}) =>
      ApiResponse._(error: error, statusCode: statusCode);

  final T? data;
  final String? error;
  final int? statusCode;

  bool get isSuccess => error == null;
}

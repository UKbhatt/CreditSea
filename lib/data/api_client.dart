import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _i = ApiClient._();
  factory ApiClient() => _i;
  ApiClient._();

  final Dio dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment
      ('API_BASE',
        defaultValue: 'http:// 192.168.218.8:8080/api'),
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 25),
    headers: {'Content-Type': 'application/json'},
  ));
  final _storage = const FlutterSecureStorage();

  void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<void> saveToken(String token) => _storage.write(key: 'jwt', value: token);
  Future<void> clearToken() => _storage.delete(key: 'jwt');
}
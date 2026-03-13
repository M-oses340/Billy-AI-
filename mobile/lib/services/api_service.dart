import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  static const String baseUrl = 'http://localhost:3000/api';

  ApiService() : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Map<String, dynamic>> get(String path) async {
    final response = await _dio.get(path);
    return response.data;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final response = await _dio.post(path, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    final response = await _dio.put(path, data: data);
    return response.data;
  }

  Future<void> delete(String path) async {
    await _dio.delete(path);
  }
}

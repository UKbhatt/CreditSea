import 'api_client.dart';

class AuthService {
  final _api = ApiClient();

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await _api.dio.post('/auth/register', data: data);
    await _api.saveToken(res.data['token']);
    return res.data['user'];
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _api.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    await _api.saveToken(res.data['token']);
    return res.data['user'];
  }

  Future<Map<String, dynamic>> me() async {
    final res = await _api.dio.get('/auth/me');
    return res.data;
  }

  Future<void> logout() => _api.clearToken();
}

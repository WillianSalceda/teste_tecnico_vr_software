import '../../../../core/api/api_client.dart';
import '../../domain/entities/session.dart';

abstract class IAuthRemoteDatasource {
  Future<Session> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  AuthRemoteDatasource(this._api);

  final ApiClient _api;

  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      '/api/auth/login',
      body: {'username': username, 'password': password},
      fromJson: (j) => j,
    );
    if (!res.isSuccess || res.data == null) {
      throw Exception(res.error ?? 'Unknown error');
    }
    final token = res.data!['token'] as String?;
    final user = res.data!['username'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Invalid response: missing token');
    }
    return Session(token: token, username: user ?? username);
  }
}

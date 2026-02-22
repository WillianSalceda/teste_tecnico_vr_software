import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/modules/auth/data/datasources/auth_local_storage.dart';
import 'package:real_estate_app/modules/auth/data/datasources/auth_remote_datasource.dart';
import 'package:real_estate_app/modules/auth/data/repositories/auth_repository.dart';
import 'package:real_estate_app/modules/auth/domain/entities/session.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockAuthRemoteDatasource mockRemote;
    late MockAuthLocalStorage mockLocal;

    setUp(() {
      mockRemote = MockAuthRemoteDatasource();
      mockLocal = MockAuthLocalStorage();
      repository = AuthRepository(mockRemote, mockLocal);
    });

    test('login returns Right with session on success', () async {
      final session = Session(token: 'token-123', username: 'admin');
      mockRemote.loginResult = session;

      final result = await repository.login(
        username: 'admin',
        password: 'admin123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (s) {
          expect(s.token, 'token-123');
          expect(s.username, 'admin');
        },
      );
      expect(mockLocal.savedSession, session);
    });

    test('login returns Left on remote exception', () async {
      mockRemote.loginThrows = Exception('Invalid credentials');

      final result = await repository.login(
        username: 'admin',
        password: 'wrong',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f.message, contains('Invalid credentials')),
        (_) => fail('Expected Left'),
      );
    });

    test('logout clears local storage', () async {
      await repository.logout();

      expect(mockLocal.cleared, isTrue);
    });

    test('getSession returns session from local storage', () async {
      final session = Session(token: 't', username: 'u');
      mockLocal.sessionResult = session;

      final result = await repository.getSession();

      expect(result, session);
    });

    test('getSession returns null when local has no session', () async {
      mockLocal.sessionResult = null;

      final result = await repository.getSession();

      expect(result, isNull);
    });
  });
}

class MockAuthRemoteDatasource implements IAuthRemoteDatasource {
  Session? loginResult;
  Exception? loginThrows;

  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    if (loginThrows != null) throw loginThrows!;
    return loginResult!;
  }
}

class MockAuthLocalStorage implements IAuthLocalStorage {
  Session? savedSession;
  bool cleared = false;
  Session? sessionResult;

  @override
  Future<void> saveSession(Session session) async {
    savedSession = session;
  }

  @override
  Future<void> clearSession() async {
    cleared = true;
  }

  @override
  Future<Session?> getSession() async => sessionResult;
}

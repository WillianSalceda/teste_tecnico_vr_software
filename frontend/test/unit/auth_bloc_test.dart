import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/modules/auth/data/datasources/auth_local_storage.dart';
import 'package:real_estate_app/modules/auth/data/datasources/auth_remote_datasource.dart';
import 'package:real_estate_app/modules/auth/data/repositories/auth_repository.dart';
import 'package:real_estate_app/modules/auth/domain/entities/session.dart';
import 'package:real_estate_app/modules/auth/domain/usecases/get_session.dart';
import 'package:real_estate_app/modules/auth/domain/usecases/login.dart';
import 'package:real_estate_app/modules/auth/domain/usecases/logout.dart';
import 'package:real_estate_app/modules/auth/presentation/bloc/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    late MockAuthRemoteDatasource mockRemote;
    late MockAuthLocalStorage mockLocal;
    late AuthRepository repository;
    late AuthBloc bloc;

    setUp(() {
      mockRemote = MockAuthRemoteDatasource();
      mockLocal = MockAuthLocalStorage();
      repository = AuthRepository(mockRemote, mockLocal);
      bloc = AuthBloc(
        Login(repository),
        Logout(repository),
        GetSession(repository),
      );
    });

    tearDown(() => bloc.close());

    const session = Session(token: 'token', username: 'admin');

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthCheckRequested and session exists',
      build: () {
        mockLocal.sessionResult = session;
        return bloc;
      },
      act: (b) => b.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(session),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when AuthCheckRequested and no session',
      build: () {
        mockLocal.sessionResult = null;
        return bloc;
      },
      act: (b) => b.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthLoginRequested succeeds',
      build: () {
        mockRemote.loginResult = session;
        return bloc;
      },
      act: (b) => b.add(
        const AuthLoginRequested(
          username: 'admin',
          password: 'admin123',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(session),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when AuthLoginRequested fails',
      build: () {
        mockRemote.loginThrows = Exception('Invalid credentials');
        return bloc;
      },
      act: (b) => b.add(
        const AuthLoginRequested(
          username: 'admin',
          password: 'wrong',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when AuthLogoutRequested',
      build: () => bloc,
      act: (b) => b.add(const AuthLogoutRequested()),
      expect: () => [const AuthUnauthenticated()],
    );
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
  Session? sessionResult;

  @override
  Future<void> saveSession(Session session) async {}

  @override
  Future<void> clearSession() async {}

  @override
  Future<Session?> getSession() async => sessionResult;
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_storage.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepository implements IAuthRepository {
  AuthRepository(this._remote, this._local);

  final IAuthRemoteDatasource _remote;
  final IAuthLocalStorage _local;

  @override
  Future<Either<Failure, Session>> login({
    required String username,
    required String password,
  }) async {
    try {
      final session = await _remote.login(
        username: username,
        password: password,
      );
      await _local.saveSession(session);
      return Right(session);
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    await _local.clearSession();
  }

  @override
  Future<Session?> getSession() async {
    return _local.getSession();
  }
}

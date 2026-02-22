import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/session.dart';

abstract class IAuthRepository {
  Future<Either<Failure, Session>> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<Session?> getSession();
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/i_auth_repository.dart';

class LoginParams {
  const LoginParams({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;
}

class Login implements UseCase<Session, LoginParams> {
  Login(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Either<Failure, Session>> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }

  @override
  void dispose() {}
}

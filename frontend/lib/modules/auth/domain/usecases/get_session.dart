import '../entities/session.dart';
import '../repositories/i_auth_repository.dart';

class GetSession {
  GetSession(this._repository);

  final IAuthRepository _repository;

  Future<Session?> call() {
    return _repository.getSession();
  }

  void dispose() {}
}

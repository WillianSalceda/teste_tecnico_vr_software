import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  Logout(this._repository);

  final IAuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await _repository.logout();
      return const Right(null);
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  @override
  void dispose() {}
}

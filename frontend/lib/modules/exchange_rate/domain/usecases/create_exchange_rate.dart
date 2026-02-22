import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exchange_rate.dart';
import '../repositories/i_exchange_rate_repository.dart';

class CreateExchangeRate implements UseCase<ExchangeRate, double> {
  CreateExchangeRate(this._repository);

  final IExchangeRateRepository _repository;

  @override
  Future<Either<Failure, ExchangeRate>> call(double params) {
    return _repository.create(params);
  }

  @override
  void dispose() {}
}

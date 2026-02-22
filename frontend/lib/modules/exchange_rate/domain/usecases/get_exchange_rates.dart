import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_exchange_rate_repository.dart';

class GetExchangeRates
    implements UseCase<ListExchangeRatesResult, GetExchangeRatesParams> {
  GetExchangeRates(this._repository);

  final IExchangeRateRepository _repository;

  @override
  Future<Either<Failure, ListExchangeRatesResult>> call(
    GetExchangeRatesParams params,
  ) {
    return _repository.list(
      page: params.page,
      limit: params.limit,
    );
  }

  @override
  void dispose() {}
}

class GetExchangeRatesParams {
  const GetExchangeRatesParams({
    this.page = 1,
    this.limit = 10,
  });

  final int page;
  final int limit;
}

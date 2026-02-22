import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/i_exchange_rate_repository.dart';
import '../datasources/exchange_rate_remote_datasource.dart';
import '../mappers/exchange_rate_mapper.dart';

class ExchangeRateRepository implements IExchangeRateRepository {
  ExchangeRateRepository(this._datasource);

  final IExchangeRateRemoteDatasource _datasource;

  @override
  Future<Either<Failure, ExchangeRate>> create(double rate) async {
    try {
      final entity = await _datasource.create(rate);
      return Right(entity);
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ListExchangeRatesResult>> list({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final json = await _datasource.fetchList(page: page, limit: limit);
      final list = json['exchange_rates'] as List<dynamic>? ?? [];
      final total = json['total'] as int? ?? 0;
      final rates = list
          .cast<Map<String, dynamic>>()
          .map(ExchangeRateMapper.fromJson)
          .toList();
      return Right(ListExchangeRatesResult(exchangeRates: rates, total: total));
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}

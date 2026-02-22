import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/exchange_rate.dart';

class ListExchangeRatesResult {
  const ListExchangeRatesResult({
    required this.exchangeRates,
    required this.total,
  });

  final List<ExchangeRate> exchangeRates;
  final int total;
}

abstract class IExchangeRateRepository {
  Future<Either<Failure, ExchangeRate>> create(double rate);

  Future<Either<Failure, ListExchangeRatesResult>> list({
    int page = 1,
    int limit = 10,
  });
}

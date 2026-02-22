import '../../../../core/api/api_client.dart';
import '../../domain/entities/exchange_rate.dart';
import '../mappers/exchange_rate_mapper.dart';

abstract class IExchangeRateRemoteDatasource {
  Future<ExchangeRate> create(double rate);

  Future<Map<String, dynamic>> fetchList({int page = 1, int limit = 10});
}

class ExchangeRateRemoteDatasource implements IExchangeRateRemoteDatasource {
  ExchangeRateRemoteDatasource(this._api);

  final ApiClient _api;

  @override
  Future<ExchangeRate> create(double rate) async {
    final res = await _api.post<Map<String, dynamic>>(
      '/api/v1/exchange-rates',
      body: {'rate': rate},
      fromJson: (j) => j,
    );
    if (!res.isSuccess || res.data == null) {
      throw Exception(res.error ?? 'Unknown error');
    }
    return ExchangeRateMapper.fromJson(res.data!);
  }

  @override
  Future<Map<String, dynamic>> fetchList({
    int page = 1,
    int limit = 10,
  }) async {
    final res = await _api.get<Map<String, dynamic>>(
      '/api/v1/exchange-rates',
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
      fromJson: (j) => j,
    );
    if (!res.isSuccess || res.data == null) {
      throw Exception(res.error ?? 'Unknown error');
    }
    return res.data!;
  }
}

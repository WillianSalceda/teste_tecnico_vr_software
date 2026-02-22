import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/modules/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import 'package:real_estate_app/modules/exchange_rate/data/repositories/exchange_rate_repository.dart';
import 'package:real_estate_app/modules/exchange_rate/domain/entities/exchange_rate.dart';

void main() {
  group('ExchangeRateRepository', () {
    late ExchangeRateRepository repository;
    late MockExchangeRateRemoteDatasource mockDatasource;

    setUp(() {
      mockDatasource = MockExchangeRateRemoteDatasource();
      repository = ExchangeRateRepository(mockDatasource);
    });

    test('list returns Right with parsed data on success', () async {
      mockDatasource.listResult = {
        'exchange_rates': [
          {
            'id': 'id-1',
            'rate': 0.19,
            'valid_from': '2024-01-15T10:00:00.000Z',
            'valid_to': null,
            'created_at': '2024-01-15T10:00:00.000Z',
          },
        ],
        'total': 1,
      };

      final result = await repository.list(page: 1, limit: 10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.exchangeRates.length, 1);
          expect(data.exchangeRates.first.rate, 0.19);
          expect(data.total, 1);
        },
      );
    });

    test('list returns Left on datasource exception', () async {
      mockDatasource.listThrows = Exception('Network error');

      final result = await repository.list(page: 1, limit: 10);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Network error')),
        (_) => fail('Expected Left'),
      );
    });

    test('create returns Right on success', () async {
      mockDatasource.createResult = _createEntity(0.19);

      final result = await repository.create(0.19);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.rate, 0.19),
      );
    });

    test('create returns Left on datasource exception', () async {
      mockDatasource.createThrows = Exception('Server error');

      final result = await repository.create(0.19);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Server error')),
        (_) => fail('Expected Left'),
      );
    });
  });
}

class MockExchangeRateRemoteDatasource
    implements IExchangeRateRemoteDatasource {
  Map<String, dynamic>? listResult;
  Exception? listThrows;
  ExchangeRate? createResult;
  Exception? createThrows;

  @override
  Future<Map<String, dynamic>> fetchList({
    int page = 1,
    int limit = 10,
  }) async {
    if (listThrows != null) throw listThrows!;
    return listResult ?? {'exchange_rates': [], 'total': 0};
  }

  @override
  Future<ExchangeRate> create(double rate) async {
    if (createThrows != null) throw createThrows!;
    return createResult!;
  }
}

ExchangeRate _createEntity(double rate) => ExchangeRate(
  id: 'id',
  rate: rate,
  validFrom: DateTime.now(),
  createdAt: DateTime.now(),
);

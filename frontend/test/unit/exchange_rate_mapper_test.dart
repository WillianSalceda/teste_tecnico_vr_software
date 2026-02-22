import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/modules/exchange_rate/data/mappers/exchange_rate_mapper.dart';

void main() {
  group('ExchangeRateMapper', () {
    test('fromJson parses API response correctly', () {
      final json = {
        'id': 'uuid-123',
        'rate': 0.19,
        'valid_from': '2024-01-15T10:00:00.000Z',
        'valid_to': null,
        'created_at': '2024-01-15T10:00:00.000Z',
      };

      final rate = ExchangeRateMapper.fromJson(json);

      expect(rate.id, 'uuid-123');
      expect(rate.rate, 0.19);
      expect(rate.validFrom, DateTime.utc(2024, 1, 15, 10, 0, 0));
      expect(rate.validTo, isNull);
      expect(rate.createdAt, DateTime.utc(2024, 1, 15, 10, 0, 0));
    });

    test('fromJson parses validTo when present', () {
      final json = {
        'id': 'uuid-456',
        'rate': 0.20,
        'valid_from': '2024-01-10T08:00:00.000Z',
        'valid_to': '2024-01-15T10:00:00.000Z',
        'created_at': '2024-01-10T08:00:00.000Z',
      };

      final rate = ExchangeRateMapper.fromJson(json);

      expect(rate.rate, 0.20);
      expect(rate.validTo, DateTime.utc(2024, 1, 15, 10, 0, 0));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/modules/listing/data/mappers/address_mapper.dart';
import 'package:real_estate_app/modules/listing/data/mappers/listing_mapper.dart';
import 'package:real_estate_app/modules/listing/domain/entities/listing.dart';

void main() {
  group('ListingMapper', () {
    test('fromJson parses API response correctly', () {
      final json = {
        'id': 'uuid-123',
        'type': 'sale',
        'value_brl': 500000.0,
        'value_usd': 100000.0,
        'image_url': 'https://example.com/img.jpg',
        'address': {
          'cep': '01310100',
          'street': 'Av Paulista',
          'number': '1000',
          'complement': null,
          'neighborhood': 'Bela Vista',
          'city': 'São Paulo',
          'state': 'SP',
        },
        'created_at': '2024-01-15T10:00:00.000Z',
      };

      final listing = ListingMapper.fromJson(json);

      expect(listing.id, 'uuid-123');
      expect(listing.type, ListingType.sale);
      expect(listing.valueBRL, 500000.0);
      expect(listing.valueUSD, 100000.0);
      expect(listing.imageUrl, 'https://example.com/img.jpg');
      expect(listing.address.cep, '01310100');
      expect(listing.address.street, 'Av Paulista');
      expect(listing.address.number, '1000');
      expect(listing.address.neighborhood, 'Bela Vista');
      expect(listing.address.city, 'São Paulo');
      expect(listing.address.state, 'SP');
      expect(listing.typeLabel, 'sale');
    });

    test('fromJson parses rent type correctly', () {
      final json = {
        'id': 'uuid-456',
        'type': 'rent',
        'value_brl': 3000.0,
        'value_usd': null,
        'image_url': null,
        'address': {
          'cep': '',
          'street': 'Rua X',
          'neighborhood': 'Centro',
          'city': 'Rio',
          'state': 'RJ',
        },
        'created_at': '2024-01-16T12:00:00.000Z',
      };

      final listing = ListingMapper.fromJson(json);

      expect(listing.type, ListingType.rent);
      expect(listing.valueUSD, isNull);
      expect(listing.imageUrl, isNull);
      expect(listing.typeLabel, 'rent');
    });
  });

  group('AddressMapper', () {
    test(
      'fromJson handles ViaCEP format',
      () {
        final json = {
          'cep': '01310100',
          'logradouro': 'Avenida Paulista',
          'complemento': '',
          'bairro': 'Bela Vista',
          'localidade': 'São Paulo',
          'uf': 'SP',
        };

        final address = AddressMapper.fromJson(json);

        expect(address.cep, '01310100');
        expect(address.street, 'Avenida Paulista');
        expect(address.neighborhood, 'Bela Vista');
        expect(address.city, 'São Paulo');
        expect(address.state, 'SP');
        expect(address.isComplete, isTrue);
      },
    );

    test(
      'fromJson handles standard format',
      () {
        final json = {
          'cep': '01310100',
          'street': 'Av Paulista',
          'number': '500',
          'complement': 'Sala 1',
          'neighborhood': 'Bela Vista',
          'city': 'São Paulo',
          'state': 'SP',
        };

        final address = AddressMapper.fromJson(json);

        expect(address.street, 'Av Paulista');
        expect(address.number, '500');
        expect(address.complement, 'Sala 1');
      },
    );
  });
}

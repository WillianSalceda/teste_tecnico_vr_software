import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/core/errors/failures.dart';
import 'package:real_estate_app/modules/create_listing/domain/entities/address.dart';
import 'package:real_estate_app/modules/create_listing/domain/repositories/i_address_repository.dart';
import 'package:real_estate_app/modules/create_listing/domain/usecases/get_address_by_cep.dart';
import 'package:real_estate_app/modules/create_listing/presentation/bloc/cep_bloc.dart';

void main() {
  group('CepBloc', () {
    late MockAddressRepository mockRepo;
    late GetAddressByCep getAddressByCep;
    late CepBloc bloc;

    setUp(() {
      mockRepo = MockAddressRepository();
      getAddressByCep = GetAddressByCep(mockRepo);
      bloc = CepBloc(getAddressByCep);
    });

    tearDown(() => bloc.close());

    const successAddress = Address(
      cep: '01310-100',
      street: 'Avenida Paulista',
      neighborhood: 'Bela Vista',
      city: 'São Paulo',
      state: 'SP',
    );

    blocTest<CepBloc, CepState>(
      'emits [CepLoading, CepLoaded] when CepLookupRequested succeeds',
      build: () {
        mockRepo.getByCepResult = const Right(successAddress);
        return bloc;
      },
      act: (b) => b.add(const CepLookupRequested('01310100')),
      expect: () => [
        CepLoading(),
        const CepLoaded(successAddress),
      ],
    );

    blocTest<CepBloc, CepState>(
      'emits [CepLoading, CepError] when CepLookupRequested fails',
      build: () {
        mockRepo.getByCepResult = Left(LocalFailure(message: 'CEP not found'));
        return bloc;
      },
      act: (b) => b.add(const CepLookupRequested('00000000')),
      expect: () => [
        CepLoading(),
        const CepError('CEP not found'),
      ],
    );
  });
}

class MockAddressRepository implements IAddressRepository {
  Either<Failure, Address>? getByCepResult;

  @override
  Future<Either<Failure, Address>> getByCep(String cep) async =>
      getByCepResult ?? Left(LocalFailure(message: 'not mocked'));
}

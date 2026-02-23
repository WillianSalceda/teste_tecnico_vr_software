import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/core/errors/failures.dart';
import 'package:real_estate_app/modules/create_listing/domain/entities/address.dart';
import 'package:real_estate_app/modules/create_listing/domain/repositories/i_create_listing_repository.dart';
import 'package:real_estate_app/modules/create_listing/domain/usecases/create_listing.dart';
import 'package:real_estate_app/modules/create_listing/presentation/bloc/create_listing_bloc.dart';

void main() {
  group('CreateListingBloc', () {
    late MockCreateListingRepository mockRepo;

    setUp(() {
      mockRepo = MockCreateListingRepository();
    });

    CreateListingBloc createBloc() =>
        CreateListingBloc(CreateListing(mockRepo));

    void fillValidForm(CreateListingBloc b) {
      b.valueController.text = '100000';
      b.cepController.text = '01310100';
      b.streetController.text = 'Avenida Paulista';
      b.neighborhoodController.text = 'Bela Vista';
      b.cityController.text = 'São Paulo';
      b.stateController.text = 'SP';
    }

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [formState with addressFilledFromCep] when CepLookupSucceeded',
      build: createBloc,
      act: (b) {
        b.add(
          const CepLookupSucceeded(
            Address(
              cep: '01310-100',
              street: 'Avenida Paulista',
              neighborhood: 'Bela Vista',
              city: 'São Paulo',
              state: 'SP',
            ),
          ),
        );
      },
      expect: () => [
        const CreateListingFormState(addressFilledFromCep: true),
      ],
    );

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [formState with type] when CreateListingTypeChanged',
      build: createBloc,
      act: (b) => b.add(const CreateListingTypeChanged('rent')),
      expect: () => [
        const CreateListingFormState(type: 'rent'),
      ],
    );

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [formState with imagePath] when CreateListingImagePathChanged',
      build: createBloc,
      act: (b) => b.add(const CreateListingImagePathChanged('/path/to/image')),
      expect: () => [
        const CreateListingFormState(imagePath: '/path/to/image'),
      ],
    );

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [loading, formState success, NavigateState] when CreateListingSubmitted succeeds',
      build: () {
        mockRepo.createResult = const Right(null);
        final b = createBloc();
        fillValidForm(b);
        return b;
      },
      act: (b) => b.add(const CreateListingSubmitted()),
      expect: () => [
        const CreateListingFormState(
          isLoading: true,
          errorMessage: null,
          success: false,
        ),
        const CreateListingFormState(
          isLoading: false,
          success: true,
          errorMessage: null,
          type: 'sale',
          imagePath: null,
        ),
        const CreateListingNavigateState('/listings'),
      ],
    );

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [loading, formState with errorMessage] when CreateListingSubmitted fails',
      build: () {
        mockRepo.createResult = Left(LocalFailure(message: 'invalidValue'));
        final b = createBloc();
        fillValidForm(b);
        return b;
      },
      act: (b) => b.add(const CreateListingSubmitted()),
      expect: () => [
        const CreateListingFormState(
          isLoading: true,
          errorMessage: null,
          success: false,
        ),
        const CreateListingFormState(
          isLoading: false,
          errorMessage: 'invalidValue',
          success: false,
        ),
      ],
    );

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [FormState] when AddressRevalidationHandled',
      build: createBloc,
      seed: () => const CreateListingFormState(addressFilledFromCep: true),
      act: (b) => b.add(const AddressRevalidationHandled()),
      expect: () => [
        const CreateListingFormState(addressFilledFromCep: false),
      ],
    );

    blocTest<CreateListingBloc, CreateListingState>(
      'emits [FormState] when NavigationHandled',
      build: createBloc,
      act: (b) => b.add(const NavigationHandled()),
      expect: () => [
        const CreateListingFormState(
          success: true,
          type: 'sale',
          isLoading: false,
        ),
      ],
    );
  });
}

class MockCreateListingRepository implements ICreateListingRepository {
  Either<Failure, void>? createResult;

  @override
  Future<Either<Failure, void>> create({
    required String type,
    required double valueBRL,
    required Map<String, dynamic> addressJson,
    String? imagePath,
    String? imageUrl,
  }) async => createResult ?? const Right(null);
}

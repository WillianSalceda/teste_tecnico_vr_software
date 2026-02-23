import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/core/errors/failures.dart';
import 'package:real_estate_app/modules/listing/domain/repositories/i_listing_repository.dart';
import 'package:real_estate_app/modules/listing/domain/usecases/get_listings.dart';
import 'package:real_estate_app/modules/listing/presentation/bloc/listing_bloc.dart';

void main() {
  group('ListingBloc', () {
    late MockListingRepository mockRepo;
    late GetListings getListings;
    late ListingBloc bloc;

    setUp(() {
      mockRepo = MockListingRepository();
      getListings = GetListings(mockRepo);
      bloc = ListingBloc(getListings);
    });

    tearDown(() => bloc.close());

    blocTest<ListingBloc, ListingState>(
      'emits [ListingFilterUpdated] when ListingFilterChanged',
      build: () => bloc,
      act: (b) => b.add(const ListingFilterChanged('sale')),
      expect: () => [
        const ListingFilterUpdated(typeFilter: 'sale'),
      ],
    );

    blocTest<ListingBloc, ListingState>(
      'emits [ListingFilterUpdated with null] when ListingFilterChanged to null',
      build: () => bloc,
      act: (b) => b.add(const ListingFilterChanged(null)),
      expect: () => [
        const ListingFilterUpdated(typeFilter: null),
      ],
    );

    test('fetchPage returns listings on success', () async {
      mockRepo.listResult = const Right(
        ListListingsResult(
          listings: [],
          total: 0,
        ),
      );
      final result = await bloc.fetchPage(1, null);
      expect(result, isEmpty);
    });

    test('fetchPage throws on failure', () async {
      mockRepo.listResult = Left(LocalFailure(message: 'error'));
      expect(
        bloc.fetchPage(1, null),
        throwsA(isA<Exception>()),
      );
    });
  });
}

class MockListingRepository implements IListingRepository {
  Either<Failure, ListListingsResult>? listResult;

  @override
  Future<Either<Failure, ListListingsResult>> list({
    int page = 1,
    int limit = 10,
    String? type,
  }) async =>
      listResult ?? const Right(ListListingsResult(listings: [], total: 0));
}

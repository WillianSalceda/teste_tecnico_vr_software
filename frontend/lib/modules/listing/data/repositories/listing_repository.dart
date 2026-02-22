import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_listing_repository.dart';
import '../datasources/listing_remote_datasource.dart';
import '../mappers/listing_mapper.dart';

class ListingRepository implements IListingRepository {
  ListingRepository(this._datasource);

  final IListingRemoteDatasource _datasource;

  @override
  Future<Either<Failure, ListListingsResult>> list({
    int page = 1,
    int limit = 10,
    String? type,
  }) async {
    try {
      final json = await _datasource.fetchListings(
        page: page,
        limit: limit,
        type: type,
      );
      final list = json['listings'] as List<dynamic>? ?? [];
      final total = json['total'] as int? ?? 0;
      final listings = list
          .cast<Map<String, dynamic>>()
          .map(ListingMapper.fromJson)
          .toList();
      return Right(ListListingsResult(listings: listings, total: total));
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}

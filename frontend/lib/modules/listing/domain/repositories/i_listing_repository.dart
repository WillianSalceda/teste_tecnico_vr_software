import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/listing.dart';

class ListListingsResult {
  const ListListingsResult({
    required this.listings,
    required this.total,
  });

  final List<Listing> listings;
  final int total;
}

abstract class IListingRepository {
  Future<Either<Failure, ListListingsResult>> list({
    int page = 1,
    int limit = 10,
    String? type,
  });
}

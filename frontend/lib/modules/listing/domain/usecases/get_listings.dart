import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_listing_repository.dart';

class GetListings implements UseCase<ListListingsResult, GetListingsParams> {
  GetListings(this._repository);

  final IListingRepository _repository;

  @override
  Future<Either<Failure, ListListingsResult>> call(GetListingsParams params) {
    return _repository.list(
      page: params.page,
      limit: params.limit,
      type: params.type,
    );
  }

  @override
  void dispose() {}
}

class GetListingsParams {
  const GetListingsParams({
    this.page = 1,
    this.limit = 10,
    this.type,
  });

  final int page;
  final int limit;
  final String? type;
}

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_create_listing_repository.dart';
import '../datasources/create_listing_remote_datasource.dart';

class CreateListingRepository implements ICreateListingRepository {
  CreateListingRepository(this._datasource);

  final ICreateListingRemoteDatasource _datasource;

  @override
  Future<Either<Failure, void>> create({
    required String type,
    required double valueBRL,
    required Map<String, dynamic> addressJson,
    String? imagePath,
    String? imageUrl,
  }) async {
    try {
      var url = imageUrl;
      if (url == null && imagePath != null) {
        url = await _datasource.uploadFile(imagePath);
      }
      await _datasource.createListing(
        type: type,
        valueBRL: valueBRL,
        imageUrl: url,
        addressJson: addressJson,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}

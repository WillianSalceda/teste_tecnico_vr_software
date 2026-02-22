import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class ICreateListingRepository {
  Future<Either<Failure, void>> create({
    required String type,
    required double valueBRL,
    required Map<String, dynamic> addressJson,
    String? imagePath,
    String? imageUrl,
  });
}

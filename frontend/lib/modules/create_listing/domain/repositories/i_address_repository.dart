import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/address.dart';

abstract class IAddressRepository {
  Future<Either<Failure, Address>> getByCep(String cep);
}

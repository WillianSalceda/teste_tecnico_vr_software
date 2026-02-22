import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/i_address_repository.dart';

class GetAddressByCep implements UseCase<Address, GetAddressByCepParams> {
  GetAddressByCep(this._repository);

  final IAddressRepository _repository;

  @override
  Future<Either<Failure, Address>> call(GetAddressByCepParams params) {
    return _repository.getByCep(params.cep);
  }

  @override
  void dispose() {}
}

class GetAddressByCepParams {
  const GetAddressByCepParams(this.cep);

  final String cep;
}

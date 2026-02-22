import 'package:dartz/dartz.dart';

import '../../../../core/errors/enums.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/i_address_repository.dart';
import '../datasources/address_remote_datasource.dart';
import '../mappers/address_mapper.dart';

class AddressRepository implements IAddressRepository {
  AddressRepository(this._datasource);

  final IAddressRemoteDatasource _datasource;

  @override
  Future<Either<Failure, Address>> getByCep(String cep) async {
    try {
      final json = await _datasource.fetchByCep(cep);
      return Right(AddressMapper.fromJson(json));
    } on FormatException catch (_) {
      return Left(LocalFailure(message: 'invalid_cep'));
    } on CepNotFoundException catch (_) {
      return Left(
        ServerFailure(
          status: ErrorStatus.unknown,
          message: 'not_found',
        ),
      );
    } on AddressServiceUnavailableException catch (_) {
      return Left(
        ServerFailure(
          status: ErrorStatus.unknown,
          message: 'service_unavailable',
        ),
      );
    } on Exception catch (e) {
      return Left(
        LocalFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}

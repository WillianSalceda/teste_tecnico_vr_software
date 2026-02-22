import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_create_listing_repository.dart';

class CreateListing implements UseCase<void, CreateListingParams> {
  CreateListing(this._repository);

  final ICreateListingRepository _repository;

  @override
  Future<Either<Failure, void>> call(CreateListingParams params) async {
    final validationFailure = _validate(params);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    final valueBRL = double.parse(
      params.valueStr.replaceAll(',', '.'),
    );

    final addressJson = _buildAddressJson(params);

    return _repository.create(
      type: params.type,
      valueBRL: valueBRL,
      imagePath: params.imagePath,
      imageUrl: params.imageUrl,
      addressJson: addressJson,
    );
  }

  Failure? _validate(CreateListingParams params) {
    if (params.street.trim().isEmpty ||
        params.neighborhood.trim().isEmpty ||
        params.city.trim().isEmpty ||
        params.state.trim().isEmpty) {
      return LocalFailure(message: 'requiredField');
    }

    final value = double.tryParse(
      params.valueStr.replaceAll(',', '.'),
    );
    if (value == null || value <= 0) {
      return LocalFailure(message: 'invalidValue');
    }

    if (params.type != 'sale' && params.type != 'rent') {
      return LocalFailure(message: 'invalidType');
    }

    return null;
  }

  Map<String, dynamic> _buildAddressJson(CreateListingParams params) {
    return {
      'cep': params.cep.trim(),
      'street': params.street.trim(),
      if (params.number != null && params.number!.trim().isNotEmpty)
        'number': params.number!.trim(),
      if (params.complement != null && params.complement!.trim().isNotEmpty)
        'complement': params.complement!.trim(),
      'neighborhood': params.neighborhood.trim(),
      'city': params.city.trim(),
      'state': params.state.trim(),
    };
  }

  @override
  void dispose() {}
}

class CreateListingParams {
  const CreateListingParams({
    required this.type,
    required this.valueStr,
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    this.number,
    this.complement,
    this.imagePath,
    this.imageUrl,
  });

  final String type;
  final String valueStr;
  final String cep;
  final String street;
  final String? number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String? imagePath;
  final String? imageUrl;
}

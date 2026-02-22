import '../../../../core/api/api_client.dart';

abstract class IAddressRemoteDatasource {
  Future<Map<String, dynamic>> fetchByCep(String cep);
}

class AddressRemoteDatasource implements IAddressRemoteDatasource {
  AddressRemoteDatasource(this._api);

  final ApiClient _api;

  @override
  Future<Map<String, dynamic>> fetchByCep(String cep) async {
    final cepDigits = cep.replaceAll(RegExp(r'\D'), '');
    if (cepDigits.length != 8) {
      throw const FormatException('invalid_cep');
    }
    final res = await _api.get<Map<String, dynamic>>(
      '/api/v1/address/cep/$cepDigits',
      fromJson: (j) => j,
    );
    if (!res.isSuccess) {
      if (res.statusCode == 404) throw CepNotFoundException();
      if (res.statusCode == 503) throw AddressServiceUnavailableException();
      throw Exception(res.error ?? 'unknown');
    }
    return res.data!;
  }
}

class CepNotFoundException implements Exception {}

class AddressServiceUnavailableException implements Exception {}

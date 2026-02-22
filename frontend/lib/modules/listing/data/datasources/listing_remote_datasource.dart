import '../../../../core/api/api_client.dart';

abstract class IListingRemoteDatasource {
  Future<Map<String, dynamic>> fetchListings({
    int page = 1,
    int limit = 10,
    String? type,
  });
}

class ListingRemoteDatasource implements IListingRemoteDatasource {
  ListingRemoteDatasource(this._api);

  final ApiClient _api;

  @override
  Future<Map<String, dynamic>> fetchListings({
    int page = 1,
    int limit = 10,
    String? type,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (type != null && type.isNotEmpty) {
      queryParams['type'] = type;
    }
    final res = await _api.get<Map<String, dynamic>>(
      '/api/v1/listings',
      queryParams: queryParams,
      fromJson: (j) => j,
    );
    if (!res.isSuccess || res.data == null) {
      throw Exception(res.error ?? 'Unknown error');
    }
    return res.data!;
  }
}

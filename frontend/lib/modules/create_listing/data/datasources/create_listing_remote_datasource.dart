import 'dart:io';

import '../../../../core/api/api_client.dart';

abstract class ICreateListingRemoteDatasource {
  Future<String?> uploadFile(String path);

  Future<void> createListing({
    required String type,
    required double valueBRL,
    required Map<String, dynamic> addressJson,
    String? imageUrl,
  });
}

class CreateListingRemoteDatasource implements ICreateListingRemoteDatasource {
  CreateListingRemoteDatasource(this._api);

  final ApiClient _api;

  @override
  Future<String?> uploadFile(String path) async {
    final file = File(path);
    final res = await _api.uploadFile<Map<String, dynamic>>(
      '/api/v1/upload',
      file,
      fromJson: (j) => j,
    );
    if (!res.isSuccess || res.data == null) return null;
    return res.data!['url'] as String?;
  }

  @override
  Future<void> createListing({
    required String type,
    required double valueBRL,
    required Map<String, dynamic> addressJson,
    String? imageUrl,
  }) async {
    final body = <String, dynamic>{
      'type': type,
      'value_brl': valueBRL,
      'address': addressJson,
    };
    if (imageUrl != null) body['image_url'] = imageUrl;
    final res = await _api.post<Map<String, dynamic>>(
      '/api/v1/listings',
      body: body,
      fromJson: (j) => j,
    );
    if (!res.isSuccess) {
      throw Exception(res.error ?? 'Unknown error');
    }
  }
}

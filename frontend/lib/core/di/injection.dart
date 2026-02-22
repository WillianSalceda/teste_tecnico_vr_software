import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../modules/create_listing/data/datasources/address_remote_datasource.dart';
import '../../modules/create_listing/data/datasources/create_listing_remote_datasource.dart';
import '../../modules/create_listing/data/repositories/address_repository.dart';
import '../../modules/create_listing/data/repositories/create_listing_repository.dart';
import '../../modules/create_listing/domain/repositories/i_address_repository.dart';
import '../../modules/create_listing/domain/repositories/i_create_listing_repository.dart';
import '../../modules/create_listing/domain/usecases/create_listing.dart';
import '../../modules/create_listing/domain/usecases/get_address_by_cep.dart';
import '../../modules/create_listing/presentation/bloc/cep_bloc.dart';
import '../../modules/create_listing/presentation/bloc/create_listing_bloc.dart';
import '../api/api_client.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies({
  required String apiBaseUrl,
  required Locale locale,
}) async {
  sl
    ..registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: apiBaseUrl))
    ..registerLazySingleton<Locale>(() => locale);

  // create_listing
  sl
    ..registerFactory<IAddressRemoteDatasource>(
      () => AddressRemoteDatasource(sl<ApiClient>()),
    )
    ..registerFactory<IAddressRepository>(
      () => AddressRepository(sl<IAddressRemoteDatasource>()),
    )
    ..registerFactory<GetAddressByCep>(
      () => GetAddressByCep(sl<IAddressRepository>()),
    )
    ..registerFactory<CepBloc>(() => CepBloc(sl<GetAddressByCep>()));

  sl
    ..registerFactory<ICreateListingRemoteDatasource>(
      () => CreateListingRemoteDatasource(sl<ApiClient>()),
    )
    ..registerFactory<ICreateListingRepository>(
      () => CreateListingRepository(sl<ICreateListingRemoteDatasource>()),
    )
    ..registerFactory<CreateListing>(
      () => CreateListing(sl<ICreateListingRepository>()),
    )
    ..registerFactory<CreateListingBloc>(
      () => CreateListingBloc(sl<CreateListing>()),
    );
}

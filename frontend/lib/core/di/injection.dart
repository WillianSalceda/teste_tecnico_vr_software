import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/auth/data/datasources/auth_local_storage.dart';
import '../../modules/auth/data/datasources/auth_remote_datasource.dart';
import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/domain/repositories/i_auth_repository.dart';
import '../../modules/auth/domain/usecases/get_session.dart';
import '../../modules/auth/domain/usecases/login.dart';
import '../../modules/auth/domain/usecases/logout.dart';
import '../../modules/auth/presentation/bloc/auth_bloc.dart';
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
import '../../modules/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import '../../modules/exchange_rate/data/repositories/exchange_rate_repository.dart';
import '../../modules/exchange_rate/domain/repositories/i_exchange_rate_repository.dart';
import '../../modules/exchange_rate/domain/usecases/create_exchange_rate.dart';
import '../../modules/exchange_rate/domain/usecases/get_exchange_rates.dart';
import '../../modules/exchange_rate/presentation/bloc/exchange_rate_bloc.dart';
import '../../modules/listing/data/datasources/listing_remote_datasource.dart';
import '../../modules/listing/data/repositories/listing_repository.dart';
import '../../modules/listing/domain/repositories/i_listing_repository.dart';
import '../../modules/listing/domain/usecases/get_listings.dart';
import '../../modules/listing/presentation/bloc/listing_bloc.dart';
import '../api/api_client.dart';
import '../refresh/auth_refresh_notifier.dart';
import '../refresh/listing_refresh_notifier.dart';
import '../session/session_expired_notifier.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies({
  required String apiBaseUrl,
  required String authBaseUrl,
  required Locale locale,
}) async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton<SessionExpiredNotifier>(SessionExpiredNotifier.new)
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: apiBaseUrl,
        getToken: () async => (await sl<GetSession>()())?.token,
        onSessionExpired: () => sl<SessionExpiredNotifier>().notify(),
      ),
    )
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(baseUrl: authBaseUrl),
      instanceName: 'auth',
    )
    ..registerLazySingleton<Locale>(() => locale)
    ..registerLazySingleton<ListingRefreshNotifier>(
      () => ListingRefreshNotifier(),
    )
    ..registerLazySingleton<AuthRefreshNotifier>(
      () => AuthRefreshNotifier(),
    );

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

  // exchange_rate
  sl
    ..registerFactory<IExchangeRateRemoteDatasource>(
      () => ExchangeRateRemoteDatasource(sl<ApiClient>()),
    )
    ..registerFactory<IExchangeRateRepository>(
      () => ExchangeRateRepository(sl<IExchangeRateRemoteDatasource>()),
    )
    ..registerFactory<GetExchangeRates>(
      () => GetExchangeRates(sl<IExchangeRateRepository>()),
    )
    ..registerFactory<CreateExchangeRate>(
      () => CreateExchangeRate(sl<IExchangeRateRepository>()),
    )
    ..registerFactory<ExchangeRateBloc>(
      () => ExchangeRateBloc(
        sl<GetExchangeRates>(),
        sl<CreateExchangeRate>(),
      ),
    );

  // auth
  sl
    ..registerFactory<IAuthRemoteDatasource>(
      () => AuthRemoteDatasource(sl<ApiClient>(instanceName: 'auth')),
    )
    ..registerFactory<IAuthLocalStorage>(
      () => AuthLocalStorage(prefs),
    )
    ..registerFactory<IAuthRepository>(
      () => AuthRepository(
        sl<IAuthRemoteDatasource>(),
        sl<IAuthLocalStorage>(),
      ),
    )
    ..registerFactory<Login>(() => Login(sl<IAuthRepository>()))
    ..registerFactory<Logout>(() => Logout(sl<IAuthRepository>()))
    ..registerFactory<GetSession>(() => GetSession(sl<IAuthRepository>()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        sl<Login>(),
        sl<Logout>(),
        sl<GetSession>(),
      ),
    );

  // listing
  sl
    ..registerFactory<IListingRemoteDatasource>(
      () => ListingRemoteDatasource(sl<ApiClient>()),
    )
    ..registerFactory<IListingRepository>(
      () => ListingRepository(sl<IListingRemoteDatasource>()),
    )
    ..registerFactory<GetListings>(
      () => GetListings(sl<IListingRepository>()),
    )
    ..registerFactory<ListingBloc>(
      () => ListingBloc(sl<GetListings>()),
    );
}

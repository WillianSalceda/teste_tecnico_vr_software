// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Real Estate Ads';

  @override
  String get listings => 'Listings';

  @override
  String get createListing => 'Create Listing';

  @override
  String get exchangeRates => 'Exchange Rates';

  @override
  String get addExchangeRate => 'Add Exchange Rate';

  @override
  String get type => 'Type';

  @override
  String get sale => 'Sale';

  @override
  String get rent => 'Rent';

  @override
  String get valueBRL => 'Value (BRL)';

  @override
  String get valueUSD => 'Value (USD)';

  @override
  String get image => 'Image';

  @override
  String get address => 'Address';

  @override
  String get cep => 'CEP';

  @override
  String get street => 'Street';

  @override
  String get number => 'Number';

  @override
  String get complement => 'Complement';

  @override
  String get neighborhood => 'Neighborhood';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get searchByCep => 'Search by CEP';

  @override
  String get rate => 'Rate (1 BRL = X USD)';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get cepNotFound => 'CEP not found';

  @override
  String get addressServiceUnavailable => 'Address lookup service unavailable';

  @override
  String get fillAddressManually => 'Please fill the address manually';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidCep => 'Invalid CEP format';

  @override
  String get noImage => 'No image';

  @override
  String get page => 'Page';

  @override
  String pageOf(int total) {
    return 'of $total';
  }

  @override
  String get filterByType => 'Filter by type';

  @override
  String get all => 'All';
}

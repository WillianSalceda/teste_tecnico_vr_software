import 'package:flutter/material.dart';

class AppL10n {
  AppL10n({this.locale = const Locale('en')});

  final Locale locale;

  bool get isPt => locale.languageCode == 'pt';

  String get appTitle => isPt ? 'Anúncios de Imóveis' : 'Real Estate Ads';

  String get listings => isPt ? 'Anúncios' : 'Listings';

  String get createListing => isPt ? 'Criar Anúncio' : 'Create Listing';

  String get exchangeRates => isPt ? 'Cotações' : 'Exchange Rates';

  String get addExchangeRate =>
      isPt ? 'Adicionar Cotação' : 'Add Exchange Rate';

  String get type => isPt ? 'Tipo' : 'Type';

  String get sale => isPt ? 'Venda' : 'Sale';

  String get rent => isPt ? 'Aluguel' : 'Rent';

  String get valueBRL => isPt ? 'Valor (BRL)' : 'Value (BRL)';

  String get valueUSD => isPt ? 'Valor (USD)' : 'Value (USD)';

  String get image => isPt ? 'Imagem' : 'Image';

  String get address => isPt ? 'Endereço' : 'Address';

  String get cep => isPt ? 'CEP' : 'CEP';

  String get street => isPt ? 'Rua' : 'Street';

  String get number => isPt ? 'Número' : 'Number';

  String get complement => isPt ? 'Complemento' : 'Complement';

  String get neighborhood => isPt ? 'Bairro' : 'Neighborhood';

  String get city => isPt ? 'Cidade' : 'City';

  String get state => isPt ? 'Estado' : 'State';

  String get searchByCep => isPt ? 'Buscar por CEP' : 'Search by CEP';

  String get rate => isPt ? 'Taxa (1 BRL = X USD)' : 'Rate (1 BRL = X USD)';

  String get save => isPt ? 'Salvar' : 'Save';

  String get cancel => isPt ? 'Cancelar' : 'Cancel';

  String get loading => isPt ? 'Carregando...' : 'Loading...';

  String get error => isPt ? 'Erro' : 'Error';

  String get cepNotFound => isPt ? 'CEP não encontrado' : 'CEP not found';

  String get addressServiceUnavailable => isPt
      ? 'Serviço de consulta de CEP indisponível'
      : 'Address lookup service unavailable';

  String get fillAddressManually => isPt
      ? 'Preencha o endereço manualmente'
      : 'Please fill the address manually';

  String get requiredField =>
      isPt ? 'Este campo é obrigatório' : 'This field is required';

  String get invalidCep =>
      isPt ? 'Formato de CEP inválido' : 'Invalid CEP format';

  String get noImage => isPt ? 'Sem imagem' : 'No image';

  String get page => isPt ? 'Página' : 'Page';

  String of(int total) => isPt ? 'de $total' : 'of $total';

  String get filterByType => isPt ? 'Filtrar por tipo' : 'Filter by type';

  String get all => isPt ? 'Todos' : 'All';

  String get listingCreatedSuccess =>
      isPt ? 'Anúncio criado com sucesso' : 'Listing created successfully';

  String get invalidValue => isPt ? 'Valor inválido' : 'Invalid value';

  String get invalidType => isPt ? 'Tipo inválido' : 'Invalid type';

  String get noListings =>
      isPt ? 'Nenhum anúncio encontrado' : 'No listings found';

  String get retry => isPt ? 'Tentar novamente' : 'Retry';

  String get exchangeRateCreatedSuccess => isPt
      ? 'Cotação adicionada com sucesso'
      : 'Exchange rate added successfully';

  String get invalidRate => isPt
      ? 'Taxa inválida (deve ser maior que zero)'
      : 'Invalid rate (must be greater than zero)';

  String get noExchangeRates =>
      isPt ? 'Nenhuma cotação cadastrada' : 'No exchange rates yet';

  String get login => isPt ? 'Entrar' : 'Login';

  String get logout => isPt ? 'Sair' : 'Logout';

  String get username => isPt ? 'Usuário' : 'Username';

  String get password => isPt ? 'Senha' : 'Password';

  String get loginFailed =>
      isPt ? 'Usuário ou senha inválidos' : 'Invalid username or password';
}

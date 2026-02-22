// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Anúncios de Imóveis';

  @override
  String get listings => 'Anúncios';

  @override
  String get createListing => 'Criar Anúncio';

  @override
  String get exchangeRates => 'Cotações';

  @override
  String get addExchangeRate => 'Adicionar Cotação';

  @override
  String get type => 'Tipo';

  @override
  String get sale => 'Venda';

  @override
  String get rent => 'Aluguel';

  @override
  String get valueBRL => 'Valor (BRL)';

  @override
  String get valueUSD => 'Valor (USD)';

  @override
  String get image => 'Imagem';

  @override
  String get address => 'Endereço';

  @override
  String get cep => 'CEP';

  @override
  String get street => 'Rua';

  @override
  String get number => 'Número';

  @override
  String get complement => 'Complemento';

  @override
  String get neighborhood => 'Bairro';

  @override
  String get city => 'Cidade';

  @override
  String get state => 'Estado';

  @override
  String get searchByCep => 'Buscar por CEP';

  @override
  String get rate => 'Taxa (1 BRL = X USD)';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get cepNotFound => 'CEP não encontrado';

  @override
  String get addressServiceUnavailable =>
      'Serviço de consulta de CEP indisponível';

  @override
  String get fillAddressManually => 'Preencha o endereço manualmente';

  @override
  String get requiredField => 'Este campo é obrigatório';

  @override
  String get invalidCep => 'Formato de CEP inválido';

  @override
  String get noImage => 'Sem imagem';

  @override
  String get page => 'Página';

  @override
  String pageOf(int total) {
    return 'de $total';
  }

  @override
  String get filterByType => 'Filtrar por tipo';

  @override
  String get all => 'Todos';
}

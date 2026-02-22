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

  @override
  String get listingCreatedSuccess => 'Anúncio criado com sucesso';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get invalidType => 'Tipo inválido';

  @override
  String get noListings => 'Nenhum anúncio encontrado';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get exchangeRateCreatedSuccess => 'Cotação adicionada com sucesso';

  @override
  String get invalidRate => 'Taxa inválida (deve ser maior que zero)';

  @override
  String get noExchangeRates => 'Nenhuma cotação cadastrada';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get username => 'Usuário';

  @override
  String get password => 'Senha';

  @override
  String get loginFailed => 'Usuário ou senha inválidos';

  @override
  String get sessionExpired =>
      'Sua sessão expirou. Por favor, faça login novamente.';

  @override
  String get testCredentials => 'Credenciais de teste: admin / admin123';

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get uploadFailed => 'Falha no envio do arquivo';

  @override
  String get invalidResponseMissingToken => 'Resposta inválida: token ausente';

  @override
  String get rateExampleHint => '0,19';

  @override
  String get cepHint => '00000-000';
}

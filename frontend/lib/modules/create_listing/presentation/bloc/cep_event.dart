part of 'cep_bloc.dart';

abstract class CepEvent extends Equatable {
  const CepEvent();

  @override
  List<Object?> get props => [];
}

class CepLookupRequested extends CepEvent {
  const CepLookupRequested(this.cep);

  final String cep;

  @override
  List<Object?> get props => [cep];
}

part of 'cep_bloc.dart';

abstract class CepState extends Equatable {
  const CepState();

  @override
  List<Object?> get props => [];
}

class CepInitial extends CepState {}

class CepLoading extends CepState {}

class CepLoaded extends CepState {
  const CepLoaded(this.address);

  final Address address;

  @override
  List<Object?> get props => [address];
}

class CepError extends CepState {
  const CepError(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

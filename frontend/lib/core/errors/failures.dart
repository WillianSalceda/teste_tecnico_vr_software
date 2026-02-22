import 'package:equatable/equatable.dart';

import 'enums.dart';

abstract class Failure extends Equatable {
  final ErrorStatus? status;
  final String message;

  const Failure({required this.message, this.status});
}

class ServerFailure implements Failure {
  @override
  final ErrorStatus status;
  @override
  final String message;

  ServerFailure({required this.status, required this.message});

  @override
  List<Object> get props => [status, message];

  @override
  bool? get stringify => true;
}

class LocalFailure implements Failure {
  @override
  final ErrorStatus? status;
  @override
  final String message;

  LocalFailure({required this.message, this.status});

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
